package com.github.chistousov.authorization_backend.controllers;

import java.net.URI;

import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.WebSession;

import com.github.chistousov.authorization_backend.models.AcceptLoginRequestModelBuilder;
import com.github.chistousov.authorization_backend.models.ErrorModelBuilder;
import com.github.chistousov.authorization_backend.models.PostLoginModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;
import com.github.chistousov.authorization_backend.services.OryHydraService;
import com.github.chistousov.authorization_backend.services.UserService;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("login")
@Slf4j
public class LoginProviderController {

  private static final String NUMBER_OF_LOGIN_ATTEMPTS_ZERO = "Количество попыток входа истекло";
  private static final String NUMBER_OF_LOGIN_ATTEMPTS = "number_of_login_attempts";
  private static final String LOGIN_CHALLENGE = "login_challenge";

  private UserService userService;
  private OryHydraService oryHydraService;

  // number of login attempts
  private int numberOfLoginAttempts;

  private String frontendURI;

  public LoginProviderController(Environment env, UserService userService, OryHydraService oryHydraService) {

    this.userService = userService;
    this.oryHydraService = oryHydraService;

    this.numberOfLoginAttempts = Integer
        .parseUnsignedInt(env.getProperty("application.ory-hydra.number-of-login-attempts", "5"));

    this.frontendURI = env.getProperty("application.ory-hydra.frontend.login-redirectURI");
  }

  @GetMapping
  public Mono<ResponseEntity<Object>> getLogin(@RequestParam(LOGIN_CHALLENGE) String loginChallenge,
      WebSession webSession) {

    return oryHydraService.loginRequestInfo(loginChallenge)
        .flatMap(loginRequestInfo -> {

          // if the user has logged in before
          if (loginRequestInfo.getSkip().booleanValue()) {

            // login validation model
            var acceptLoginRequestModel = userService
                .getUser(loginRequestInfo.getSubject())
                .map(
                    userModel -> AcceptLoginRequestModelBuilder.builder()
                        .setSubject(userModel.getLogin())
                        .setRemember(true)
                        // if getIsRemember == true, then remember for a day
                        .setRememberFor(60L * 60L * 24L)
                        .build());

            return oryHydraService.acceptLoginRequest(
                loginChallenge,
                acceptLoginRequestModel)
                // redirect browser
                .map(responseWithRedirectModel -> ResponseEntity
                    .status(HttpStatus.FOUND)
                    .location(URI.create(responseWithRedirectModel.getRedirectTo()))
                    .build())
                .doOnEach(el -> log.info("User already logged in"));
          }

          // remember login challenge ID
          webSession.getAttributes().put(LOGIN_CHALLENGE, loginChallenge);
          // set the number of login attempts
          webSession.getAttributes().put(NUMBER_OF_LOGIN_ATTEMPTS, String.valueOf(numberOfLoginAttempts));

          return Mono.just(
              ResponseEntity
                  .status(HttpStatus.FOUND)
                  .location(URI.create(frontendURI))
                  .build())
              .doOnEach(el -> log.info("User gets login page"));
        });
  }

  @PostMapping
  public Mono<ResponseEntity<ResponseWithRedirectModel>> postLogin(@RequestBody PostLoginModel postLoginModel,
      WebSession webSession) {

    // get loginChallenge
    String loginChallenge = webSession.getRequiredAttribute(LOGIN_CHALLENGE).toString();
    // get the number of attempts
    long numberAttempts = Long.parseUnsignedLong(webSession.getRequiredAttribute(NUMBER_OF_LOGIN_ATTEMPTS));

    if (numberAttempts == 0L) {
      var errorModel = Mono.just(
          ErrorModelBuilder
              .builder()
              .setError("request_denied")
              .setErrorDebug(NUMBER_OF_LOGIN_ATTEMPTS_ZERO)
              .setErrorDescription(
                  "The number of login attempts has expired! Close the tab and re-login to the app.")
              .setErrorHint(NUMBER_OF_LOGIN_ATTEMPTS_ZERO)
              .setStatusCode(401L)
              .build());

      return oryHydraService.rejectLoginRequest(
          loginChallenge,
          errorModel)
          // redirect browser
          .map(responseWithRedirectModel -> ResponseEntity
              .status(HttpStatus.CREATED)
              .body(responseWithRedirectModel))
          .doOnEach(el -> log.info(NUMBER_OF_LOGIN_ATTEMPTS_ZERO));
    }

    numberAttempts--;

    webSession.getAttributes().put(NUMBER_OF_LOGIN_ATTEMPTS, String.valueOf(numberAttempts));

    // Mono to validate user into database by password
    return userService
        .getUserAndCheck(postLoginModel.getLogin(), postLoginModel.getPassword())
        .flatMap(user -> {

          var acceptLoginRequestModel = Mono.just(
              AcceptLoginRequestModelBuilder.builder()
                  .setSubject(user.getLogin())
                  .setRemember(postLoginModel.getIsRemember())
                  // if getIsRemember == true, then remember for a day
                  .setRememberFor(60L * 60L * 24L)
                  .build());

          return oryHydraService.acceptLoginRequest(loginChallenge, acceptLoginRequestModel)
              // redirect browser
              .map(responseWithRedirectModel -> {

                webSession.getAttributes().remove(LOGIN_CHALLENGE);
                webSession.getAttributes().remove(NUMBER_OF_LOGIN_ATTEMPTS);

                return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(responseWithRedirectModel);
              });
        })
        .doOnEach(el -> log.info("Login закончился успехом. Переходит на consent."));

  }

}
