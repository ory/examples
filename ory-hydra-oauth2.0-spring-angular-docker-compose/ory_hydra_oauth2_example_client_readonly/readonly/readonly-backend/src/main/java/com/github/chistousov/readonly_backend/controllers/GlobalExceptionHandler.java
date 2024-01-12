package com.github.chistousov.readonly_backend.controllers;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.support.WebExchangeBindException;

import com.github.chistousov.readonly_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@ControllerAdvice
@Slf4j
@ExcludeFromJacocoGeneratedReport
public class GlobalExceptionHandler {

  private static final String TEXT_PLAIN_CHARSET_UTF_8 = "text/plain;charset=utf-8";
  private static final String CONTENT_TYPE = "Content-Type";

  // invalid model handler
  @ExceptionHandler(WebExchangeBindException.class)
  public ResponseEntity<List<String>> handleException(WebExchangeBindException e) {
    var errors = e.getBindingResult()
        .getAllErrors()
        .stream()
        .map(DefaultMessageSourceResolvable::getDefaultMessage)
        .collect(Collectors.toList());
    return ResponseEntity.badRequest().body(errors);

  }

  @ExceptionHandler(IllegalArgumentException.class)
  public Mono<Void> illegalArgumentPerfom(ServerHttpRequest req, ServerHttpResponse response,
      IllegalArgumentException ex) {

    response.getHeaders().set(CONTENT_TYPE, TEXT_PLAIN_CHARSET_UTF_8);
    response.setStatusCode(HttpStatus.BAD_REQUEST);

    byte[] bodyResponse = "Request received with incorrect data ".getBytes(StandardCharsets.UTF_8);
    DataBuffer buffer = response.bufferFactory().wrap(bodyResponse);

    return response.writeWith(Flux.just(buffer))
        .doOnEach(el -> log.error(req.getPath().toString() + " ", ex));

  }

  @ExceptionHandler(Exception.class)
  public Mono<Void> commonHandler(ServerHttpRequest req, ServerHttpResponse response, Exception ex) {

    response.getHeaders().set(CONTENT_TYPE, TEXT_PLAIN_CHARSET_UTF_8);
    response.setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);

    byte[] bodyResponse = "Error in server ".getBytes(StandardCharsets.UTF_8);
    DataBuffer buffer = response.bufferFactory().wrap(bodyResponse);

    return response.writeWith(Flux.just(buffer))
        .doOnEach(el -> log.error(req.getPath().toString() + " ", ex));
  }

}
