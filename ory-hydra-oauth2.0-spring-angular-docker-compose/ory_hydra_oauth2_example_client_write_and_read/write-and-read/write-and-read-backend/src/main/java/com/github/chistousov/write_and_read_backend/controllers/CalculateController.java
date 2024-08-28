package com.github.chistousov.write_and_read_backend.controllers;

import java.net.URI;

import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.annotation.RegisteredOAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.web.reactive.function.client.ServerOAuth2AuthorizedClientExchangeFilterFunction;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.WebSession;
import org.springframework.web.util.UriComponentsBuilder;

import reactor.core.publisher.Mono;

@Controller
@RequestMapping("/change")
public class CalculateController {

  private WebClient webClient;
  private URI locationResourceServer;

  private URI locationCalculate;

  public CalculateController(WebClient webClient, Environment env) {
    this.webClient = webClient;
    this.locationResourceServer = URI.create(
        env.getRequiredProperty(
            "application.resource-server"));

    this.locationCalculate = UriComponentsBuilder
        .fromUri(locationResourceServer)
        .pathSegment("api", "calculate")
        .build()
        .toUri();
  }

  @PutMapping
  public Mono<ResponseEntity<Object>> calculate(
      @RegisteredOAuth2AuthorizedClient("client-write-and-read") OAuth2AuthorizedClient authorizedClient,
      WebSession webSession) {

    return Mono.just(
        ResponseEntity.ok(webClient.put()
            .uri(locationCalculate)
            .attributes(
                ServerOAuth2AuthorizedClientExchangeFilterFunction
                    .oauth2AuthorizedClient(
                        authorizedClient))
            .retrieve()
            .bodyToMono(Object.class)));

  }
}
