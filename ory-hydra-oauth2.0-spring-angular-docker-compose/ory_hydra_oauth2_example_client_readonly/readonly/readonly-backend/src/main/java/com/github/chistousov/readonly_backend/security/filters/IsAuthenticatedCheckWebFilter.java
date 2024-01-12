package com.github.chistousov.readonly_backend.security.filters;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatcher;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatcher.MatchResult;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatchers;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import reactor.core.publisher.Mono;

public class IsAuthenticatedCheckWebFilter implements WebFilter {

  private static final String AUTHENTICATION_FRONTEND = "/authenticate-frontend";

  private ServerWebExchangeMatcher requiresLoggedInMatcher = ServerWebExchangeMatchers.pathMatchers(HttpMethod.GET,
      "/logged-in");

  private String json;

  public IsAuthenticatedCheckWebFilter() throws JsonProcessingException {
    Map<String, String> payload = new HashMap<>();
    payload.put("redirect_to", AUTHENTICATION_FRONTEND);

    json = new ObjectMapper().writeValueAsString(payload);
  }

  @Override
  public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
    // проверяем есть аутентификация и авторизация

    // соответствует URI /logged-in
    return this.requiresLoggedInMatcher.matches(exchange)
        .filter(MatchResult::isMatch)
        // request не соответствует /logged-in, тогда пропускаем
        .switchIfEmpty(chain.filter(exchange).then(Mono.empty()))
        // есть ли контекст безопасности?
        .flatMap(matchResult -> ReactiveSecurityContextHolder
            .getContext()
            // нету констекста безопасности значит создаем фиктивный объект
            .switchIfEmpty(Mono.just(new SecurityContextImpl())))
        .flatMap(securityContext -> {
          Authentication authentication = securityContext.getAuthentication();
          // нету констекста безопасности или не аутентифицирован
          if (authentication == null || !authentication.isAuthenticated()) {

            return Mono.defer(() -> {
              ServerHttpResponse response = exchange.getResponse();
              response.setStatusCode(HttpStatus.UNAUTHORIZED);
              response.getHeaders().setContentType(MediaType.TEXT_PLAIN);

              DataBuffer dataBuffer = response.bufferFactory()
                  .wrap(json.getBytes(StandardCharsets.UTF_8));

              return response.writeAndFlushWith(Mono.just(Mono.just(dataBuffer)))
                  .doOnError(ex -> DataBufferUtils.release(dataBuffer));
            });
          }

          // иначе 204 - все хорошо!
          return Mono.fromRunnable(() -> {
            ServerHttpResponse response = exchange.getResponse();
            response.setStatusCode(HttpStatus.NO_CONTENT);
            response.getHeaders().setContentType(MediaType.TEXT_PLAIN);
          });
        });
  }

}
