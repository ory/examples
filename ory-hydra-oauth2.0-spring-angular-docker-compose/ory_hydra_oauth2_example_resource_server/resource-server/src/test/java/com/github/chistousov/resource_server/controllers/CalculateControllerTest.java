package com.github.chistousov.resource_server.controllers;

import static org.mockito.BDDMockito.then;

import java.io.UnsupportedEncodingException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.test.web.reactive.server.SecurityMockServerConfigurers;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.reactive.server.WebTestClient;

import com.github.chistousov.resource_server.SpringSecurityConfiguration;
import com.github.chistousov.resource_server.services.PointService;

@WebFluxTest
@Import(SpringSecurityConfiguration.class)
public class CalculateControllerTest {

  @DynamicPropertySource
  public static void settings(DynamicPropertyRegistry registry)
      throws UnsupportedEncodingException {

    registry.add("spring.security.oauth2.resourceserver.opaquetoken.client-id", () -> "1");
    registry.add("spring.security.oauth2.resourceserver.opaquetoken.client-secret", () -> "1");
    registry.add("spring.security.oauth2.resourceserver.opaquetoken.introspection-uri", () -> "1");

  }

  @Autowired
  private WebTestClient thisServerWebTestClient;

  @MockBean
  private PointService pointService;

  @Test
  @DisplayName("calculate")
  void testPostCalculate() {
    // given (instead of when)

    // when

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.mockOpaqueToken()
            .authorities(new SimpleGrantedAuthority("SCOPE_write")))
        .put()
        .uri("/calculate")
        .exchange()
        .expectStatus()
        .isOk();

    // then (instead of verify

    then(pointService)
        .should()
        .calculateNewPoint();
  }
}
