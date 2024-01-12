package com.github.chistousov.write_and_read_backend.security.auth.logout.success_handlers;

import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.server.WebFilterExchange;
import org.springframework.security.web.server.authentication.logout.ServerLogoutSuccessHandler;

import reactor.core.publisher.Mono;

public class CustomServerLogoutSuccessHandler implements ServerLogoutSuccessHandler {

  private static final HttpStatus httpStatus = HttpStatus.NO_CONTENT;

  @Override
  public Mono<Void> onLogoutSuccess(WebFilterExchange webFilterExchange, Authentication authentication) {
    return Mono.fromRunnable(() -> {
      ServerHttpResponse response = webFilterExchange.getExchange().getResponse();
      response.setStatusCode(httpStatus);
    });
  }

}
