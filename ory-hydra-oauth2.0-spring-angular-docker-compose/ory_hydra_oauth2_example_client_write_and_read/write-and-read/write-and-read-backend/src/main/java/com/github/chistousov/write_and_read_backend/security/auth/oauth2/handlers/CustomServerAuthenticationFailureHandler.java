package com.github.chistousov.write_and_read_backend.security.auth.oauth2.handlers;

import java.net.URI;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.server.WebFilterExchange;
import org.springframework.security.web.server.authentication.ServerAuthenticationFailureHandler;
import org.springframework.util.Assert;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
public class CustomServerAuthenticationFailureHandler implements ServerAuthenticationFailureHandler {

  private static final HttpStatus httpStatus = HttpStatus.FOUND;

  private static final String ERROR = "error";
  private static final String ERROR_DESCRIPTION = "error_description";
  private static final String REAUTHENTICATION_LOCATION = "reauthentication_location";

  private static final String DEFAULT_ERROR = "server_error";
  private static final String DEFAULT_ERROR_DESCRIPTION = "Неизвестная ошибка сервера";

  private URI location;
  private String reauthenticationLocation;

  public CustomServerAuthenticationFailureHandler(String location, String reauthenticationLocation) {
    Assert.notNull(location, "location cannot be null");
    Assert.notNull(reauthenticationLocation, "reauthenticationLocation cannot be null");
    this.location = URI.create(location);
    this.reauthenticationLocation = reauthenticationLocation;
  }

  @Override
  public Mono<Void> onAuthenticationFailure(WebFilterExchange webFilterExchange, AuthenticationException exception) {

    // что оправиться с редиректом
    String queryParamError = null;
    String queryParamErrorDescription = null;

    // достаем необходимые параметры запроса
    MultiValueMap<String, String> queryParamsRequest = webFilterExchange.getExchange().getRequest().getQueryParams();
    var queryParamsError = queryParamsRequest.getOrDefault(ERROR, List.of(DEFAULT_ERROR));
    var queryParamsErrorDescription = queryParamsRequest.getOrDefault(ERROR_DESCRIPTION,
        List.of(DEFAULT_ERROR_DESCRIPTION));

    queryParamError = queryParamsError.get(0);

    queryParamErrorDescription = queryParamsErrorDescription.get(0);

    // формируем необходимые параметры запроса для редиректа
    MultiValueMap<String, String> queryParamsForRedirect = new LinkedMultiValueMap<>();
    queryParamsForRedirect.add(ERROR, queryParamError);
    queryParamsForRedirect.add(ERROR_DESCRIPTION, queryParamErrorDescription);
    queryParamsForRedirect.add(REAUTHENTICATION_LOCATION, reauthenticationLocation);

    URI redirectToFrontendLocation = UriComponentsBuilder
        .fromUri(location)
        .queryParams(queryParamsForRedirect)
        .build()
        .toUri();

    return Mono.fromRunnable(() -> {
      ServerHttpResponse response = webFilterExchange.getExchange().getResponse();
      response.setStatusCode(httpStatus);

      log.debug("Redirecting to '{}'", redirectToFrontendLocation.toASCIIString());

      response.getHeaders().setLocation(redirectToFrontendLocation);

    });
  }

}
