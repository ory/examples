package com.github.chistousov.readonly_backend.controllers;

import java.net.URI;

import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.annotation.RegisteredOAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.web.reactive.function.client.ServerOAuth2AuthorizedClientExchangeFilterFunction;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.WebSession;
import org.springframework.web.util.UriComponentsBuilder;

import reactor.core.publisher.Mono;

@Controller
@RequestMapping("/data")
public class DataController {

  private WebClient webClient;
  private URI locationResourceServer;

  private URI locationStatistics;

  public DataController(WebClient webClient, Environment env) {
    this.webClient = webClient;
    this.locationResourceServer = URI.create(
        env.getRequiredProperty(
            "application.resource-server"));

    this.locationStatistics = UriComponentsBuilder
        .fromUri(locationResourceServer)
        .pathSegment("api", "statistics")
        .build()
        .toUri();
  }

  @GetMapping()
  public Mono<ResponseEntity<Object>> getStatistics(
      @RegisteredOAuth2AuthorizedClient("client-readonly") OAuth2AuthorizedClient authorizedClient,
      WebSession webSession) {

    return Mono.just(
        ResponseEntity.ok(webClient.get()
            .uri(locationStatistics)
            .attributes(
                ServerOAuth2AuthorizedClientExchangeFilterFunction
                    .oauth2AuthorizedClient(
                        authorizedClient))
            .retrieve()
            .bodyToMono(Object.class)));

  }
}
