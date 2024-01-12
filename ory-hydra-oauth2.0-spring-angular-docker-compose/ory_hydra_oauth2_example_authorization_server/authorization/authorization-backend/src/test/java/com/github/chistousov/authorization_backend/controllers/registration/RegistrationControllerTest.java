package com.github.chistousov.authorization_backend.controllers.registration;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;

import org.assertj.core.util.Arrays;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.web.reactive.server.SecurityMockServerConfigurers;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.chistousov.authorization_backend.SpringSecurityConfiguration;
import com.github.chistousov.authorization_backend.models.PostRegistrationModel;
import com.github.chistousov.authorization_backend.services.UserService;

import reactor.core.publisher.Mono;

@WebFluxTest(controllers = { RegistrationController.class })
@Import(SpringSecurityConfiguration.class)
public class RegistrationControllerTest {

  @Autowired
  private WebTestClient thisServerWebTestClient;

  @MockBean
  private UserService userService;

  private Long userIdActual = -1L;

  @Test
  @DisplayName("registration is successful")
  void testPostRegistrationSuccessful() {

    // given (instead of when)

    final Long userIdExpected = 1L;

    final PostRegistrationModel postRegistrationModel = PostRegistrationModel
        .builder()
        .login("somelogin")
        .password("zxcG2!DadD@1vxc2")
        .orgName("someOrg")
        .build();

    given(userService.createUser(postRegistrationModel)).willReturn(Mono.just(userIdExpected));

    // when

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri("/registration")
        .body(Mono.just(postRegistrationModel), PostRegistrationModel.class)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody(Long.class)
        .value(id -> userIdActual = id);

    // then (instead of verify)

    assertThat(userIdActual).isEqualTo(userIdExpected);

    then(userService)
        .should()
        .createUser(postRegistrationModel);

  }

  @Test
  @DisplayName("registration is fault")
  void testPostRegistrationFault() throws JsonProcessingException {

    // given (instead of when)

    final ObjectMapper mapper = new ObjectMapper();
    final String exMsgsExpected = mapper.writeValueAsString(
        Arrays.array("login must be greater than 4",
            "password is invalid",
            "org name must be greater than 4"));

    final PostRegistrationModel postRegistrationModel = PostRegistrationModel
        .builder()
        .login("zxc")
        .password("12")
        .orgName("qwe")
        .build();

    // when

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.csrf())
        .post()
        .uri("/registration")
        .body(Mono.just(postRegistrationModel), PostRegistrationModel.class)
        .exchange()
        .expectStatus()
        .isBadRequest()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isArray()
        .jsonPath("$.length()").isEqualTo(3)
        .jsonPath(String.format("[?($.* anyof %s)]", exMsgsExpected)).isNotEmpty();

    // then (instead of verify)

  }
}
