package com.github.chistousov.authorization_backend.controllers;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.times;

import java.io.UnsupportedEncodingException;
import java.time.Duration;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.test.web.reactive.server.SecurityMockServerConfigurers;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.github.chistousov.authorization_backend.SpringSecurityConfiguration;
import com.github.chistousov.authorization_backend.models.Client;
import com.github.chistousov.authorization_backend.models.GetConsentResponseModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;

import reactor.core.publisher.Mono;

@WebFluxTest(controllers = { ConsentProviderController.class })
@PropertySource("classpath:application.yml")
@Import(SpringSecurityConfiguration.class)
class ConsentProviderControllerTest {

  /*------- const (begin) ------- */

  private static final String frontendURI = "http://some-frontend";

  private static final String CONSENT_CHALLENGE = "consent_challenge";

  private static final String SESSION = "SESSION";

  /*------- const (end) ------- */

  @MockBean
  private OryHydraService oryHydraService;

  @Autowired
  private WebTestClient thisServerWebTestClient;

  // session this app
  private String sessionValueThisApp;

  @DynamicPropertySource
  public static void settings(DynamicPropertyRegistry registry)
      throws UnsupportedEncodingException {

    registry.add("application.ory-hydra.frontend.consent-redirectURI", () -> frontendURI);

  }

  @BeforeEach
  void setUp() {
    thisServerWebTestClient = thisServerWebTestClient.mutate()
        .responseTimeout(Duration.ofMinutes(5))
        .build();
    sessionValueThisApp = null;
  }

  @Test
  @DisplayName("full consent flow")
  void fullConsentFlow() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final String clientId = "some_client_id";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final String subject = "some subject";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .subject(subject)
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(false)
                .clientId(clientId)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", frontendURI)
        .expectCookie()
        .exists(SESSION)
        .expectCookie()
        .value(SESSION, str -> sessionValueThisApp = str);

    // get client name
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/client-name")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody(String.class)
        .isEqualTo(clientId);

    // get subject
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/subject")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody(String.class)
        .isEqualTo(subject);

    // get scope
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/scopes")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isArray()
        .jsonPath("$.length()").isEqualTo(2)
        .jsonPath("$[0]").isEqualTo(scopes.get(0))
        .jsonPath("$[1]").isEqualTo(scopes.get(1));

    // post consent
    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam("is-remember", true)
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo(responseWithRedirectModel.getRedirectTo());

    // then (instead of verify)
    then(oryHydraService)
        .should(times(5))
        .consentRequestInfo(consentChallenge);

    then(oryHydraService)
        .should()
        .acceptConsentRequest(eq(consentChallenge), any());

  }

  @Test
  @DisplayName("reconsent1")
  void reauthentication() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(true)
        .requestedScope(scopes)
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", responseWithRedirectModel.getRedirectTo());

    // then (instead of verify)
    then(oryHydraService)
        .should()
        .consentRequestInfo(consentChallenge);

    then(oryHydraService)
        .should()
        .acceptConsentRequest(eq(consentChallenge), any());

  }

  @Test
  @DisplayName("reconsent2")
  void reauthentication2() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(true)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", responseWithRedirectModel.getRedirectTo());

    // then (instead of verify)
    then(oryHydraService)
        .should()
        .consentRequestInfo(consentChallenge);

    then(oryHydraService)
        .should()
        .acceptConsentRequest(eq(consentChallenge), any());

  }

  @Test
  @DisplayName("client name 1 (clientName isBlack)")
  void clientName1() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final String clientId = "some_client_id";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(false)
                .clientName("\t")
                .clientId(clientId)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", frontendURI)
        .expectCookie()
        .exists(SESSION)
        .expectCookie()
        .value(SESSION, str -> sessionValueThisApp = str);

    // get client name
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/client-name")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody(String.class)
        .isEqualTo(clientId);

  }

  @Test
  @DisplayName("client name 2 (clientName == null)")
  void clientName2() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final String clientId = "some_client_id";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(false)
                .clientName(null)
                .clientId(clientId)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", frontendURI)
        .expectCookie()
        .exists(SESSION)
        .expectCookie()
        .value(SESSION, str -> sessionValueThisApp = str);

    // get client name
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/client-name")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody(String.class)
        .isEqualTo(clientId);

  }

  @Test
  @DisplayName("client name 3 (clientName != null)")
  void clientName3() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final String clientName = "some_client_name";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(false)
                .clientName(clientName)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.acceptConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", frontendURI)
        .expectCookie()
        .exists(SESSION)
        .expectCookie()
        .value(SESSION, str -> sessionValueThisApp = str);

    // get client name
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/client-name")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isOk()
        .expectBody(String.class)
        .isEqualTo(clientName);

  }

  @Test
  @DisplayName("full consent flow (cancel)")
  void cancelFlow() {

    // given (instead of when)

    final String consentChallenge = "some_consent_challenge";

    final String clientId = "some_client_id";

    final List<String> scopes = List.of("read", "write");

    final String redirectTo = "http://some-red";

    final GetConsentResponseModel getConsentResponseModel = GetConsentResponseModel
        .builder()
        .skip(false)
        .requestedScope(scopes)
        .client(
            Client
                .builder()
                .skipConsent(false)
                .clientId(clientId)
                .build())
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.consentRequestInfo(consentChallenge)).willReturn(Mono.just(getConsentResponseModel));

    given(oryHydraService.rejectConsentRequest(eq(consentChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    // get consent
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", frontendURI)
        .expectCookie()
        .exists(SESSION)
        .expectCookie()
        .value(SESSION, str -> sessionValueThisApp = str);

    // post consent
    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .delete()
        .uri(
            uriBuilder -> uriBuilder
                .path("/consent/cancel")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo(responseWithRedirectModel.getRedirectTo());

    // then (instead of verify)
    then(oryHydraService)
        .should()
        .consentRequestInfo(consentChallenge);

    then(oryHydraService)
        .should()
        .rejectConsentRequest(eq(consentChallenge), any());

  }

}
