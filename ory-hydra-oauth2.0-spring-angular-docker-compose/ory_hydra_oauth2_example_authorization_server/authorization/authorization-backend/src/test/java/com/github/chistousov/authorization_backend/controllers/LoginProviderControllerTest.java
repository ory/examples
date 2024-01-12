package com.github.chistousov.authorization_backend.controllers;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
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
import com.github.chistousov.authorization_backend.dao.entities.User;
import com.github.chistousov.authorization_backend.exceptions.IncorrectPasswordException;
import com.github.chistousov.authorization_backend.models.GetLoginResponseModel;
import com.github.chistousov.authorization_backend.models.PostLoginModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;
import com.github.chistousov.authorization_backend.services.UserService;

import reactor.core.publisher.Mono;

@WebFluxTest(controllers = { LoginProviderController.class })
@PropertySource("classpath:application.yml")
@Import(SpringSecurityConfiguration.class)
public class LoginProviderControllerTest {

  /*------- const (begin) ------- */

  private static final String frontendURI = "http://some-frontend";

  private static final int numberOfLoginAttempts = 3;

  private static final String LOGIN_CHALLENGE = "login_challenge";

  private static final String SESSION = "SESSION";

  /*------- const (end) ------- */

  @MockBean
  private UserService userService;
  @MockBean
  private OryHydraService oryHydraService;

  @Autowired
  private WebTestClient thisServerWebTestClient;

  // session this app
  private String sessionValueThisApp;

  @DynamicPropertySource
  public static void settings(DynamicPropertyRegistry registry)
      throws UnsupportedEncodingException {

    registry.add("application.ory-hydra.frontend.login-redirectURI", () -> frontendURI);

    registry.add("application.ory-hydra.number-of-login-attempts", () -> numberOfLoginAttempts);

  }

  @BeforeEach
  void setUp() {
    thisServerWebTestClient = thisServerWebTestClient.mutate()
        .responseTimeout(Duration.ofMinutes(5))
        .build();
    sessionValueThisApp = null;
  }

  @Test
  @DisplayName("full login flow")
  void fullLoginFlow() {

    // given (instead of when)

    final String loginChallenge = "some_login_challenge";

    final String login = "some_login";
    final String password = "some_super_pass";
    final boolean isRemember = true;

    final String redirectTo = "http://some-red";

    final GetLoginResponseModel getLoginResponseModel = GetLoginResponseModel
        .builder()
        .skip(false)
        .build();

    final PostLoginModel postLoginModel = PostLoginModel.builder()
        .login(login)
        .password(password)
        .isRemember(isRemember)
        .build();

    final User user = User.builder()
        .login(login)
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.loginRequestInfo(loginChallenge)).willReturn(Mono.just(getLoginResponseModel));

    given(userService.getUserAndCheck(login, password)).willReturn(Mono.just(user));

    given(oryHydraService.acceptLoginRequest(eq(loginChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
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

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .build())
        .body(Mono.just(postLoginModel), PostLoginModel.class)
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
        .loginRequestInfo(loginChallenge);

    then(userService)
        .should()
        .getUserAndCheck(login, password);

    then(oryHydraService)
        .should()
        .acceptLoginRequest(eq(loginChallenge), any());

  }

  @Test
  @DisplayName("reauthentication")
  void reauthentication() {

    // given (instead of when)

    final String subject = "some_subject";

    final String loginChallenge = "some_login_challenge";

    final String redirectTo = "http://some-red";

    final GetLoginResponseModel getLoginResponseModel = GetLoginResponseModel
        .builder()
        .skip(true)
        .subject(subject)
        .build();

    final User user = User.builder()
        .login(subject)
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.loginRequestInfo(loginChallenge)).willReturn(Mono.just(getLoginResponseModel));

    given(userService.getUser(subject)).willReturn(Mono.just(user));

    given(oryHydraService.acceptLoginRequest(eq(loginChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
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
        .loginRequestInfo(loginChallenge);

    then(userService)
        .should()
        .getUser(subject);

    then(oryHydraService)
        .should()
        .acceptLoginRequest(eq(loginChallenge), any());

  }

  @Test
  @DisplayName("Maximum number of login attempts exceeded")
  void exceededTheNumberOfLoginAttempts() {
    // given (instead of when)

    final String loginChallenge = "some_login_challenge";

    final String redirectTo = "http://some-red";

    final String login = "some_login";

    final String password1 = "qwerty1";
    final String password2 = "qwerty2";
    final String password3 = "qwerty3";

    PostLoginModel postLoginModel1 = new PostLoginModel(login, password1, true);
    PostLoginModel postLoginModel2 = new PostLoginModel(login, password2, true);
    PostLoginModel postLoginModel3 = new PostLoginModel(login, password3, true);

    var ex = new IncorrectPasswordException("Password is incorrect! ");

    final GetLoginResponseModel getLoginResponseModel = GetLoginResponseModel
        .builder()
        .skip(false)
        .build();

    final ResponseWithRedirectModel responseWithRedirectModel = ResponseWithRedirectModel.builder()
        .redirectTo(redirectTo)
        .build();

    given(oryHydraService.loginRequestInfo(loginChallenge)).willReturn(Mono.just(getLoginResponseModel));

    given(userService.getUserAndCheck(login, password1))
        .willThrow(ex);
    given(userService.getUserAndCheck(login, password2))
        .willThrow(ex);
    given(userService.getUserAndCheck(login, password3))
        .willThrow(ex);

    given(oryHydraService.rejectLoginRequest(eq(loginChallenge), any()))
        .willReturn(Mono.just(responseWithRedirectModel));

    // when

    thisServerWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
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

    // 1

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .build())
        .body(Mono.just(postLoginModel1), PostLoginModel.class)
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isBadRequest();

    // 2

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .build())
        .body(Mono.just(postLoginModel2), PostLoginModel.class)
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isBadRequest();

    // 3

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .build())
        .body(Mono.just(postLoginModel3), PostLoginModel.class)
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isBadRequest();

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri(
            uriBuilder -> uriBuilder
                .path("/login")
                .build())
        .body(Mono.just(postLoginModel1), PostLoginModel.class)
        .cookie(SESSION, sessionValueThisApp)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo(redirectTo);

    // then (instead of verify)

    then(oryHydraService)
        .should()
        .loginRequestInfo(loginChallenge);

    then(userService)
        .should()
        .getUserAndCheck(login, password1);

    then(userService)
        .should()
        .getUserAndCheck(login, password2);

    then(userService)
        .should()
        .getUserAndCheck(login, password3);

    then(oryHydraService)
        .should()
        .rejectLoginRequest(eq(loginChallenge), any());

  }
}
