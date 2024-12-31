package com.github.chistousov.resource_server.controllers;

import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;

import java.io.UnsupportedEncodingException;
import java.util.List;

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
import com.github.chistousov.resource_server.models.Point;
import com.github.chistousov.resource_server.services.PointService;

import reactor.core.publisher.Flux;

@WebFluxTest
@Import(SpringSecurityConfiguration.class)
public class StatisticsControllerTest {

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
  @DisplayName("get statistics")
  void testGetStatistics() {

    // given (instead of when)

    final List<Point> points = List.of(
        new Point(1, 2.3),
        new Point(2, 1.7),
        new Point(3, 5.4),
        new Point(4, 6.8),
        new Point(5, 4.2),
        new Point(6, 3.6));

    final Flux<Point> pointsFlux = Flux.fromIterable(points);

    given(pointService.getPoints()).willReturn(pointsFlux);

    // when

    thisServerWebTestClient
        .mutateWith(SecurityMockServerConfigurers.mockOpaqueToken()
            .authorities(new SimpleGrantedAuthority("SCOPE_read")))
        .get()
        .uri("/statistics")
        .exchange()
        .expectStatus()
        .isOk()
        .expectBodyList(Point.class)
        .isEqualTo(points);

    // then (instead of verify

    then(pointService)
        .should()
        .getPoints();
  }

}
