package com.github.chistousov.authorization_backend.controllers;

import java.net.URI;

import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.WebSession;

import com.github.chistousov.authorization_backend.models.PutLogoutModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("logout")
@Slf4j
public class LogoutProviderController {

  private static final String LOGOUT_CHALLENGE = "logout_challenge";

  private OryHydraService oryHydraService;

  private String frontendURI;
  private String logoutCancelfrontendURI;

  public LogoutProviderController(Environment env, OryHydraService oryHydraService) {

    this.oryHydraService = oryHydraService;

    this.frontendURI = env.getProperty("application.ory-hydra.frontend.logout-redirectURI");
    this.logoutCancelfrontendURI = env.getProperty("application.ory-hydra.frontend.logout-cancel-redirectURI");
  }

  @GetMapping
  public Mono<ResponseEntity<Object>> getLogout(@RequestParam(LOGOUT_CHALLENGE) String logoutChallenge,
      WebSession webSession) {

    return oryHydraService.logoutRequestInfo(logoutChallenge)
        .doOnNext(logoutRequestInfo -> log.info("Subject comes out: {}", logoutRequestInfo.getSubject()))
        .flatMap(logoutRequestInfo -> {

          // remember the exit attempt ID (logoutChallenge challenge)
          webSession.getAttributes().put(LOGOUT_CHALLENGE, logoutChallenge);

          return Mono.just(
              ResponseEntity
                  .status(HttpStatus.FOUND)
                  .location(URI.create(frontendURI))
                  .build())
              .doOnTerminate(
                  () -> log.info("The user receives a logout confirmation page"));
        });

  }

  @PutMapping
  public Mono<ResponseEntity<ResponseWithRedirectModel>> putLogout(@RequestBody PutLogoutModel putLogoutModel,
      WebSession webSession) {

    final String logoutChallenge = webSession.getRequiredAttribute(LOGOUT_CHALLENGE).toString();

    if (putLogoutModel.getIsConfirmed().booleanValue()) {
      return this.oryHydraService.acceptLogoutRequest(logoutChallenge)
          .log()
          .doOnNext(e -> log.info(e.toString()))
          .flatMap(
              responseWithRedirectModel -> Mono.just(
                  ResponseEntity
                      .status(HttpStatus.CREATED)
                      .body(responseWithRedirectModel))
                  .doOnTerminate(() -> log.info("The user confirmed the withdrawal")));
    }

    return this.oryHydraService.rejectLogoutRequest(logoutChallenge)
        .switchIfEmpty(
            Mono.just(
                ResponseWithRedirectModel.builder()
                    .redirectTo(logoutCancelfrontendURI)
                    .build()))
        .flatMap(
            responseWithRedirectModel -> Mono.just(
                ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(
                        responseWithRedirectModel))
                .doOnTerminate(() -> log.info("The user canceled the withdrawal")));

  }

}
