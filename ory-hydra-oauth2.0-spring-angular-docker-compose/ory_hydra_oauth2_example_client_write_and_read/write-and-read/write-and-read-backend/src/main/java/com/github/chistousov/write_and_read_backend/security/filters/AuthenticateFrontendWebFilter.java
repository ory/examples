package com.github.chistousov.write_and_read_backend.security.filters;

import java.net.URI;

import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
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

import reactor.core.publisher.Mono;

public class AuthenticateFrontendWebFilter implements WebFilter {

  private static final String AUTHENTICATION_FRONTEND = "/authenticate-frontend";

  private ServerWebExchangeMatcher requiresAuthenticateFrontendMatcher = ServerWebExchangeMatchers
      .pathMatchers(HttpMethod.GET, AUTHENTICATION_FRONTEND);

  @Override
  public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
    // endpoint, который если пользователь аутентифицирован всегда возвращает /

    // соответствует URI /authenticate-frontend
    return this.requiresAuthenticateFrontendMatcher.matches(exchange)
        .filter(MatchResult::isMatch)
        // request не соответствует /authenticate-frontend, тогда пропускаем
        .switchIfEmpty(chain.filter(exchange).then(Mono.empty()))
        // есть ли контекст безопасности?
        .flatMap(matchResult -> ReactiveSecurityContextHolder
            .getContext()
            // нету констекста безопасности значит создаем фиктивный объект
            .switchIfEmpty(Mono.just(new SecurityContextImpl())))
        .flatMap(securityContext -> {
          Authentication authentication = securityContext.getAuthentication();
          // если контекст безопасности и пользователь аутентифицирован
          if (authentication != null && authentication.isAuthenticated()) {

            return Mono.fromRunnable(() -> {
              ServerHttpResponse response = exchange.getResponse();
              response.setStatusCode(HttpStatus.FOUND);

              response.getHeaders().setLocation(URI.create("/"));
            });
          }
          // иначе обрабатываем дальше по фильтрам запрос
          return chain.filter(exchange);
        });
  }
}
