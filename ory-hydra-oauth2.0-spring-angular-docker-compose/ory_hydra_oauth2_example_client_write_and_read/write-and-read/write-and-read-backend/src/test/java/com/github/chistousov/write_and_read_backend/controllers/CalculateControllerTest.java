package com.github.chistousov.write_and_read_backend.controllers;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.AbstractMap.SimpleImmutableEntry;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockserver.client.MockServerClient;
import org.mockserver.file.FileReader;
import org.mockserver.model.Header;
import org.mockserver.model.OpenAPIDefinition;
import org.mockserver.verify.VerificationTimes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.web.util.UriComponentsBuilder;
import org.testcontainers.containers.MockServerContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.shaded.com.google.common.collect.ImmutableMap;
import org.testcontainers.utility.DockerImageName;

import com.github.chistousov.write_and_read_backend.SpringSecurityConfiguration;

import static org.mockserver.mock.OpenAPIExpectation.openAPIExpectation;
import static org.mockserver.model.HttpRequest.request;
import static org.mockserver.model.HttpResponse.response;
import static org.mockserver.model.JsonBody.json;

@WebFluxTest
@Import(SpringSecurityConfiguration.class)
@Testcontainers
public class CalculateControllerTest {

  private static final String SESSION_CLIENT = "SESSION";

  private static final DockerImageName MOCKSERVER_IMAGE = DockerImageName
      .parse("mockserver/mockserver")
      .withTag("mockserver-" + MockServerClient.class.getPackage().getImplementationVersion());

  @Container
  public static MockServerContainer oryHydraMockServer = new MockServerContainer(MOCKSERVER_IMAGE);
  private static MockServerClient oryHydraMockServerClient;

  private static final String clientId = "someUser";
  private static final String clientSecret = "someSecret";

  private static String authorizationUri;
  private static String redirectUri;

  @Container
  public static MockServerContainer resourceServerMockServer = new MockServerContainer(MOCKSERVER_IMAGE);
  private static MockServerClient resourceServerMockServerClient;

  @Autowired
  private WebTestClient thisServerWebTestClient;

  private static WebTestClient oryHydraWebTestClient;

  @DynamicPropertySource
  public static void settings(DynamicPropertyRegistry registry)
      throws UnsupportedEncodingException {

    String baseHostPath = "http://localhost:8080";

    oryHydraMockServerClient = new MockServerClient(oryHydraMockServer.getHost(),
        oryHydraMockServer.getServerPort());

    String baseOryHydraPath = String.format("http://%s:%d", oryHydraMockServer.getHost(),
        oryHydraMockServer.getServerPort());

    resourceServerMockServerClient = new MockServerClient(resourceServerMockServer.getHost(),
        resourceServerMockServer.getServerPort());

    String baseResourceServerPath = String.format("http://%s:%d", resourceServerMockServer.getHost(),
        resourceServerMockServer.getServerPort());

    registry.add("spring.security.oauth2.client.registration.client-write-and-read.client-id", () -> clientId);
    registry.add("spring.security.oauth2.client.registration.client-write-and-read.client-secret",
        () -> clientSecret);

    redirectUri = UriComponentsBuilder
        .fromUri(URI.create(baseHostPath))
        .pathSegment("login", "oauth2", "code", "client-write-and-read")
        .build()
        .toUriString();

    registry.add("spring.security.oauth2.client.registration.client-write-and-read.redirect-uri",
        () -> redirectUri);

    authorizationUri = UriComponentsBuilder
        .fromUri(URI.create(baseOryHydraPath))
        .pathSegment("oauth2", "auth")
        .build()
        .toUriString();

    oryHydraWebTestClient = WebTestClient.bindToServer()
        .baseUrl(baseOryHydraPath)
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
        .defaultHeader("X-Forwarded-Proto", "https")
        .build();

    registry.add("spring.security.oauth2.client.provider.spring.authorization-uri", () -> authorizationUri);
    registry.add("spring.security.oauth2.client.provider.spring.token-uri", () -> UriComponentsBuilder
        .fromUri(URI.create(baseOryHydraPath))
        .pathSegment("oauth2", "token")
        .build()
        .toUriString());
    registry.add("spring.security.oauth2.client.provider.spring.user-info-uri", () -> UriComponentsBuilder
        .fromUri(URI.create(baseOryHydraPath))
        .pathSegment("userinfo")
        .build()
        .toUriString());
    registry.add("spring.security.oauth2.client.provider.spring.user-name-attribute", () -> "sub");

    registry.add("application.frontend.error-oauth2-page", () -> "/error");

    registry.add("application.resource-server", () -> baseResourceServerPath);

    registry.add("server.reactive.session.cookie.name", () -> SESSION_CLIENT);
  }

  @BeforeEach
  void setUp() {
    oryHydraMockServerClient.reset();
    resourceServerMockServerClient.reset();

    thisServerWebTestClient = thisServerWebTestClient.mutate()
        .responseTimeout(Duration.ofMinutes(5))
        .build();
  }

  String authLocation;
  String cookieThisSession;

  @Test
  @DisplayName("/change is success")
  void testCalculate() {
    // given (instead of when)

    oryHydraMockServerClient
        .upsert(
            openAPIExpectation(
                FileReader.readFileFromClassPathOrPath(
                    "src/test/resources/ory-hydra-open-api-v3.json"),
                ImmutableMap.of(
                    "oAuth2Authorize", "302",
                    "getOidcUserInfo", "200")));

    oryHydraMockServerClient
        .when(
            new OpenAPIDefinition()
                .withSpecUrlOrPayload(
                    FileReader.readFileFromClassPathOrPath(
                        "src/test/resources/ory-hydra-open-api-v3.json"))
                .withOperationId("oauth2TokenExchange"))
        .respond(
            response()
                .withStatusCode(200)
                .withHeaders(new Header("Content-Type", "application/json; charset=utf-8"))
                .withBody(
                    json(
                        "{\n" +
                            "\"access_token\": \"gAanWA6Hym67rOq5k0ZGUWp3dR_fxILn3cyRj4hPt-c.wVdASIZBWL1XjHTz-3UImRkpTJLMbFwCMkPeOIh_sSM\",\n"
                            +
                            "\"expires_in\": 8888,\n" +
                            "\"id_token\": 68678,\n" +
                            "\"refresh_token\": \"gAanWA6Hym67rOq5k0ZGUWp3dR_fxILn3cyRj4hPt-c.wVdASIZBWL1XjHTz-3UImRkpTJLMbFwCMkPeOIh_sSM\",\n"
                            +
                            "\"scope\": \"read write\",\n" +
                            "\"token_type\": \"bearer\"\n" +
                            "}")));

    resourceServerMockServerClient
        .upsert(
            openAPIExpectation(
                FileReader.readFileFromClassPathOrPath(
                    "src/test/resources/resource-server-open-api-v3.json"),
                ImmutableMap.of(
                    "calculate", "200"

                )));

    // when

    // проверка аутентифицирован(и авторизован) ли пользователь без сессии
    thisServerWebTestClient
        .get()
        .uri("/logged-in")
        .exchange()
        .expectStatus()
        .isUnauthorized()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo("/authenticate-frontend");

    // аутентифицируемся
    thisServerWebTestClient
        .get()
        .uri("/authenticate-frontend")
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", "/oauth2/authorization/client-write-and-read");

    thisServerWebTestClient
        .get()
        .uri("/oauth2/authorization/client-write-and-read")
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format(
            "^http:\\/\\/%s:%d\\/oauth2\\/auth\\?response_type=code&client_id=%s&state=.+&redirect_uri=%s&code_challenge=.+&code_challenge_method=S256$",
            oryHydraMockServer.getHost(),
            oryHydraMockServer.getServerPort(),
            clientId,
            redirectUri))
        .expectHeader()
        .value("Location", location -> authLocation = location)
        .expectCookie()
        .exists(SESSION_CLIENT)
        .expectCookie()
        .value(SESSION_CLIENT, val -> cookieThisSession = val);

    URI authLocationURI = URI.create(authLocation);
    var queryParamsStrAuthLocationURI = authLocationURI.getQuery();

    var queryParamsAuthLocationURI = Arrays
        .stream(queryParamsStrAuthLocationURI.split("&"))
        .map(this::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    String state = queryParamsAuthLocationURI.get("state").get(0);

    oryHydraWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsStrAuthLocationURI)
                .build())
        .exchange()
        .expectStatus()
        .isFound();

    // прошла аутентификация и авторизация ... Получаем code в redirect uri.

    String code = "someCode";

    thisServerWebTestClient
        .get()
        .uri(

            uriBuilder -> uriBuilder
                .path("/login/oauth2/code/client-write-and-read")
                .queryParam("code", code)
                .queryParam("state", state)
                .build())
        .cookie(SESSION_CLIENT, cookieThisSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", "/")
        .expectCookie()
        .exists(SESSION_CLIENT)
        .expectCookie()
        .value(SESSION_CLIENT, val -> cookieThisSession = val);

    // Мы аутентифицированы и авторизованы

    // проверим еще раз

    thisServerWebTestClient
        .get()
        .uri("/logged-in")
        .cookie(SESSION_CLIENT, cookieThisSession)
        .exchange()
        .expectStatus()
        .isNoContent();

    thisServerWebTestClient
        .get()
        .uri("/authenticate-frontend")
        .cookie(SESSION_CLIENT, cookieThisSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", "/");

    // получем данные с сессией (аутентифицирован и авторизован)

    String tokenCSRF = generateStr();

    thisServerWebTestClient
        .put()
        .uri(

            uriBuilder -> uriBuilder
                .path("/change")
                .build())
        .cookie(SESSION_CLIENT, cookieThisSession)
        .cookie("XSRF-TOKEN", tokenCSRF)
        .header("X-XSRF-TOKEN", tokenCSRF)
        .exchange()
        .expectStatus()
        .isOk();

    // выход

    tokenCSRF = generateStr();

    thisServerWebTestClient
        .post()
        .uri(

            uriBuilder -> uriBuilder
                .path("/logout")
                .build())
        .cookie("XSRF-TOKEN", tokenCSRF)
        .header("X-XSRF-TOKEN", tokenCSRF)
        .cookie(SESSION_CLIENT, cookieThisSession)
        .exchange()
        .expectStatus()
        .isNoContent();

    // then (instead of verify

    oryHydraMockServerClient.verify(
        request()
            .withMethod("GET")
            .withPath("/oauth2/auth"),
        VerificationTimes.exactly(1));

    oryHydraMockServerClient.verify(
        request()
            .withMethod("POST")
            .withPath("/oauth2/token"),
        VerificationTimes.exactly(1));

    oryHydraMockServerClient.verify(
        request()
            .withMethod("GET")
            .withPath("/userinfo"),
        VerificationTimes.exactly(1));

    resourceServerMockServerClient.verify(
        request()
            .withMethod("PUT")
            .withPath("/api/calculate"),
        VerificationTimes.exactly(1));
  }

  @Test
  @DisplayName("/change is fauil. Token is incorrect")
  void testCalculateTokenIncorrect() {
    // given (instead of when)

    oryHydraMockServerClient
        .upsert(
            openAPIExpectation(
                FileReader.readFileFromClassPathOrPath(
                    "src/test/resources/ory-hydra-open-api-v3.json"),
                ImmutableMap.of(
                    "oAuth2Authorize", "302",
                    "oauth2TokenExchange", "200")));

    // when

    // проверка аутентифицирован(и авторизован) ли пользователь без сессии
    thisServerWebTestClient
        .get()
        .uri("/logged-in")
        .exchange()
        .expectStatus()
        .isUnauthorized()
        .expectBody()
        .jsonPath("$").isNotEmpty()
        .jsonPath("$").isMap()
        .jsonPath("$.length()").isEqualTo(1)
        .jsonPath("$.redirect_to").isNotEmpty()
        .jsonPath("$.redirect_to").isEqualTo("/authenticate-frontend");

    // аутентифицируемся
    thisServerWebTestClient
        .get()
        .uri("/authenticate-frontend")
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", "/oauth2/authorization/client-write-and-read");

    thisServerWebTestClient
        .get()
        .uri("/oauth2/authorization/client-write-and-read")
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format(
            "^http:\\/\\/%s:%d\\/oauth2\\/auth\\?response_type=code&client_id=%s&state=.+&redirect_uri=%s&code_challenge=.+&code_challenge_method=S256$",
            oryHydraMockServer.getHost(),
            oryHydraMockServer.getServerPort(),
            clientId,
            redirectUri))
        .expectHeader()
        .value("Location", location -> authLocation = location)
        .expectCookie()
        .exists(SESSION_CLIENT)
        .expectCookie()
        .value(SESSION_CLIENT, val -> cookieThisSession = val);

    URI authLocationURI = URI.create(authLocation);
    var queryParamsStrAuthLocationURI = authLocationURI.getQuery();

    var queryParamsAuthLocationURI = Arrays
        .stream(queryParamsStrAuthLocationURI.split("&"))
        .map(this::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    String state = queryParamsAuthLocationURI.get("state").get(0);

    oryHydraWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsStrAuthLocationURI)
                .build())
        .exchange()
        .expectStatus()
        .isFound();

    // прошла аутентификация и авторизация ... Получаем code в redirect uri.

    String code = "someCode";

    thisServerWebTestClient
        .get()
        .uri(

            uriBuilder -> uriBuilder
                .path("/login/oauth2/code/client-write-and-read")
                .queryParam("code", code)
                .queryParam("state", state)
                .build())
        .cookie(SESSION_CLIENT, cookieThisSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format(
            "^\\/error\\?error=%s&error_description=%s&reauthentication_location=%s$",
            "server_error",
            URLEncoder.encode("Неизвестная ошибка сервера", StandardCharsets.UTF_8).replace("+", "%20"),
            "oauth2\\/authorization\\/someUser"));

    // then (instead of verify

    oryHydraMockServerClient.verify(
        request()
            .withMethod("GET")
            .withPath("/oauth2/auth"),
        VerificationTimes.exactly(1));

    oryHydraMockServerClient.verify(
        request()
            .withMethod("POST")
            .withPath("/oauth2/token"),
        VerificationTimes.exactly(1));

  }

  @Test
  @DisplayName("/oauth2/auth is faul.")
  void fauilRequestToOryHydra() {
    // given (instead of when)

    final String error = "invalid_request";
    final String errorDescription = "Очень серьезная ошибка";

    // when

    thisServerWebTestClient
        .get()
        .uri(

            uriBuilder -> uriBuilder
                .path("/login/oauth2/code/client-write-and-read")
                .queryParam("error", error)
                .queryParam("error_description", errorDescription)
                .queryParam("state", "xyz")
                .build())
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format(
            "^\\/error\\?error=%s&error_description=%s&reauthentication_location=%s$",
            error,
            URLEncoder.encode(errorDescription, StandardCharsets.UTF_8).replace("+", "%20"),
            "oauth2\\/authorization\\/someUser"));

    // then (instead of verify

  }

  // для парсинга QueryParameter URI
  private SimpleImmutableEntry<String, String> splitQueryParameter(String it) {
    final int idx = it.indexOf("=");
    final String key = idx > 0 ? it.substring(0, idx) : it;
    final String value = idx > 0 && it.length() > idx + 1 ? it.substring(idx + 1) : null;
    return new SimpleImmutableEntry<>(
        URLDecoder.decode(key, StandardCharsets.UTF_8),
        URLDecoder.decode(value, StandardCharsets.UTF_8));
  }

  private static String generateStr() {
    // генерим случайную строки для state
    int leftLimit = 97; // letter 'a'
    int rightLimit = 122; // letter 'z'
    int targetStringLength = 30;
    Random random = new Random();
    StringBuilder buffer = new StringBuilder(targetStringLength);
    for (int i = 0; i < targetStringLength; i++) {
      int randomLimitedInt = leftLimit + (int) (random.nextFloat() * (rightLimit - leftLimit + 1));
      buffer.append((char) randomLimitedInt);
    }
    return buffer.toString();
  }
}
