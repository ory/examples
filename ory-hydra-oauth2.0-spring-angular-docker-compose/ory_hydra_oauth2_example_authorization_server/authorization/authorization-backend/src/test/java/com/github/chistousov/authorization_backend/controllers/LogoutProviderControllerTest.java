package com.github.chistousov.authorization_backend.controllers;

import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;

import java.io.UnsupportedEncodingException;
import java.time.Duration;

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
import com.github.chistousov.authorization_backend.models.GetLogoutResponseModel;
import com.github.chistousov.authorization_backend.models.PutLogoutModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;

import reactor.core.publisher.Mono;

@WebFluxTest(controllers = { LogoutProviderController.class })
@PropertySource("classpath:application.yml")
@Import(SpringSecurityConfiguration.class)
class LogoutProviderControllerTest {

  /*------- const (begin) ------- */

  private static final String frontendURI = "http://some-frontend";

  private static final String frontendURICancel = "http://some-frontend2";

  private static final String LOGOUT_CHALLENGE = "logout_challenge";

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

    registry.add("application.ory-hydra.frontend.logout-redirectURI", () -> frontendURI);
    registry.add("application.ory-hydra.frontend.logout-cancel-redirectURI", () -> frontendURICancel);

  }

  @BeforeEach
  void setUp() {
    thisServerWebTestClient = thisServerWebTestClient.mutate()
        .responseTimeout(Duration.ofMinutes(5))
        .build();
    sessionValueThisApp = null;
  }

  @Test
  @DisplayName("full logout flow")
  void fullLogoutFlow() {
    // given (instead of when)

    final String logoutChallenge = "some_logout_challenge";

    final String redirectTo = "http://some-red";

    final GetLogoutResponseModel getLogoutResponseModel = GetLogoutResponseModel
        .builder()
        .subject("some subject")
        .build();

    final PutLogoutModel putLogoutModel = PutLogoutModel
        .builder()
        .isConfirmed(true)
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.logoutRequestInfo(logoutChallenge)).willReturn(Mono.just(getLogoutResponseModel));

    given(oryHydraService.acceptLogoutRequest(logoutChallenge))
        .willReturn(Mono.just(responseWithRedirectModel));
    // when

    // get logout
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/logout")
                .queryParam(LOGOUT_CHALLENGE, logoutChallenge)
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

    // put logout
    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("/logout")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .body(Mono.just(putLogoutModel), PutLogoutModel.class)
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
        .logoutRequestInfo(logoutChallenge);

    then(oryHydraService)
        .should()
        .acceptLogoutRequest(logoutChallenge);

  }

  @Test
  @DisplayName("full logout flow (cancel)")
  void fullLogoutCancelFlow() {
    // given (instead of when)

    final String logoutChallenge = "some_logout_challenge";

    final GetLogoutResponseModel getLogoutResponseModel = GetLogoutResponseModel
        .builder()
        .subject("some subject")
        .build();

    final PutLogoutModel putLogoutModel = PutLogoutModel
        .builder()
        .isConfirmed(false)
        .build();

    given(oryHydraService.logoutRequestInfo(logoutChallenge)).willReturn(Mono.just(getLogoutResponseModel));

    given(oryHydraService.rejectLogoutRequest(logoutChallenge))
        .willReturn(Mono.empty());
    // when

    // get logout
    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/logout")
                .queryParam(LOGOUT_CHALLENGE, logoutChallenge)
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

    // put logout
    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("/logout")
                .build())
        .cookie(SESSION, sessionValueThisApp)
        .body(Mono.just(putLogoutModel), PutLogoutModel.class)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo(frontendURICancel);

    // then (instead of verify)
    then(oryHydraService)
        .should()
        .logoutRequestInfo(logoutChallenge);

    then(oryHydraService)
        .should()
        .rejectLogoutRequest(logoutChallenge);

  }

}
