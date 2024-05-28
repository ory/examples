package com.github.chistousov.authorization_backend.controllers;

import java.net.URI;
import java.util.Collections;
import java.util.List;

import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.WebSession;

import com.github.chistousov.authorization_backend.models.AcceptConsentRequestModelBuilder;
import com.github.chistousov.authorization_backend.models.ErrorModel;
import com.github.chistousov.authorization_backend.models.ErrorModelBuilder;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("consent")
@Slf4j
public class ConsentProviderController {

  private static final String CONSENT_CHALLENGE = "consent_challenge";

  private OryHydraService oryHydraService;

  private String frontendURI;

  final Mono<ErrorModel> errorModelRejectConsent = Mono.just(
      ErrorModelBuilder
          .builder()
          .setError("access_denied")
          .setErrorDescription(
              "The resource owner denied the request. ")
          .setErrorHint("")
          .setStatusCode(403L)
          .build());

  public ConsentProviderController(Environment env, OryHydraService oryHydraService) {

    this.oryHydraService = oryHydraService;

    this.frontendURI = env.getProperty("application.ory-hydra.frontend.consent-redirectURI");
  }

  @GetMapping
  public Mono<ResponseEntity<Object>> getConsent(@RequestParam(CONSENT_CHALLENGE) String consentChallenge,
      WebSession webSession) {

    return oryHydraService.consentRequestInfo(consentChallenge)
        .flatMap(consentRequestInfo -> {

          // if the user has consented in before
          if (consentRequestInfo.getSkip().booleanValue()
              || consentRequestInfo.getClient().getSkipConsent().booleanValue()) {

            var acceptConsentRequestModel = Mono.just(AcceptConsentRequestModelBuilder.builder()
                .setGrantScope(consentRequestInfo.getRequestedScope())
                .build());

            return oryHydraService.acceptConsentRequest(consentChallenge, acceptConsentRequestModel)
                // redirect browser
                .map(responseWithRedirectModel -> ResponseEntity
                    .status(HttpStatus.FOUND)
                    .location(URI.create(responseWithRedirectModel.getRedirectTo()))
                    .build())
                .doOnEach(el -> log.info("Skip consent"));

          }

          // remember consent challenge ID
          webSession.getAttributes().put(CONSENT_CHALLENGE, consentChallenge);

          return Mono.just(
              ResponseEntity
                  .status(HttpStatus.FOUND)
                  .location(URI.create(frontendURI))
                  .build())
              .doOnEach(el -> log.info("User gets consent page"));
        });
  }

  @GetMapping("subject")
  public Mono<ResponseEntity<String>> getSubject(WebSession webSession) {
    final String consentChallenge = webSession.getAttributes().get(CONSENT_CHALLENGE).toString();

    return oryHydraService.consentRequestInfo(consentChallenge)
        .map(consentRequestInfo -> ResponseEntity
            .ok(consentRequestInfo.getSubject()))
        .doOnTerminate(() -> log.info("get subject"));
  }

  @GetMapping("client-name")
  public Mono<ResponseEntity<String>> getClientName(WebSession webSession) {
    final String consentChallenge = webSession.getAttributes().get(CONSENT_CHALLENGE).toString();

    return oryHydraService.consentRequestInfo(consentChallenge)
        .map(consentRequestInfo -> {

          // client name or client Id
          String clientName = consentRequestInfo.getClient().getClientName();

          if (clientName == null || clientName.isBlank()) {
            clientName = consentRequestInfo.getClient().getClientId();
          }

          return ResponseEntity
              .ok(clientName);
        })
        .doOnTerminate(() -> log.info("get scopes"));
  }

  @GetMapping("scopes")
  public Mono<ResponseEntity<List<String>>> getScopes(WebSession webSession) {
    final String consentChallenge = webSession.getAttributes().get(CONSENT_CHALLENGE).toString();

    return oryHydraService.consentRequestInfo(consentChallenge)
        .map(consentRequestInfo -> ResponseEntity
            .ok(consentRequestInfo.getRequestedScope()))
        .doOnTerminate(() -> log.info("get scopes"));
  }

  @PutMapping
  public Mono<ResponseEntity<ResponseWithRedirectModel>> postConsentConfirm(
      @RequestParam(name = "is-remember", required = false, defaultValue = "false") boolean isRemember,
      WebSession webSession) {

    final String consentChallenge = webSession.getAttributes().get(CONSENT_CHALLENGE).toString();

    return oryHydraService.consentRequestInfo(consentChallenge)
        .flatMap(consentRequestInfo -> {

          // requested scopes
          final List<String> scopes = Collections.unmodifiableList(consentRequestInfo.getRequestedScope());

          // accept consent model
          var acceptConsentRequestModel = Mono.just(
              AcceptConsentRequestModelBuilder.builder()
                  .setGrantScope(scopes)
                  .setRemember(isRemember)
                  .build());

          return oryHydraService.acceptConsentRequest(consentChallenge, acceptConsentRequestModel)
              // redirect browser
              .map(responseWithRedirectModel -> {

                webSession.getAttributes().remove(CONSENT_CHALLENGE);

                return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(responseWithRedirectModel);
              });

        });
  }

  @DeleteMapping("cancel")
  public Mono<ResponseEntity<ResponseWithRedirectModel>> deleteConsentCancel(WebSession webSession) {

    final String consentChallenge = webSession.getAttributes().get(CONSENT_CHALLENGE).toString();

    return oryHydraService.rejectConsentRequest(consentChallenge, errorModelRejectConsent)
        // redirect browser
        .map(responseWithRedirectModel -> {

          webSession.getAttributes().remove(CONSENT_CHALLENGE);

          return ResponseEntity
              .status(HttpStatus.CREATED)
              .body(responseWithRedirectModel);
        });

  }
}
