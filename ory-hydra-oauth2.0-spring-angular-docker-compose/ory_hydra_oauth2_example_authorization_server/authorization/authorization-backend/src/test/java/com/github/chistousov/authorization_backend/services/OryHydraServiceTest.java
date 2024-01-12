package com.github.chistousov.authorization_backend.services;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.util.AbstractMap.SimpleImmutableEntry;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.testcontainers.containers.DockerComposeContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.github.chistousov.authorization_backend.SupportModule;
import com.github.chistousov.authorization_backend.TestAccessTokenExtension;
import com.github.chistousov.authorization_backend.TestIdTokenExtension;
import com.github.chistousov.authorization_backend.models.AcceptConsentRequestModelBuilder;
import com.github.chistousov.authorization_backend.models.AcceptLoginRequestModelBuilder;
import com.github.chistousov.authorization_backend.models.CreateClientModel;
import com.github.chistousov.authorization_backend.models.ErrorModelBuilder;
import com.github.chistousov.authorization_backend.models.SessionForTokenModelBuilder;

import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

@Testcontainers
@SpringBootTest
@TestMethodOrder(OrderAnnotation.class)
public class OryHydraServiceTest {

  /*------- const (begin) ------- */

  // path docker compose
  private static final File pathToResourceDockerComposeFile = Path.of("").toAbsolutePath().getParent().getParent()
      .resolve("docker-compose.yaml").toFile();

  // service name in docker compose
  private static final String hydraContainerDockerCompose = "ory-hydra-oauth2-example-authorization-server-hydra";
  // port admin Ory Hydra
  private static final int hydraAdminPortDockerCompose = 4445;
  // port public Ory Hydra
  private static final int hydraPublicPortDockerCompose = 4444;

  // subject (login) resource owner
  private static final String login = "some_login";

  // domain Ory Hydra
  private static final String AUTH_DOMAIN = "authorization-server.com";

  // session after authentication and authorization
  private static final String OAUTH2_AUTHENTICATION_SESSION = "ory_hydra_session";

  private static final String LOGIN_CHALLENGE = "login_challenge";
  private static final String CONSENT_CHALLENGE = "consent_challenge";
  private static final String CODE_CHALLENGE = "code_challenge";
  private static final String LOGOUT_CHALLENGE = "logout_challenge";

  // PKCE
  private static final String CODE_CHALLENGE_METHOD = "code_challenge_method";
  // protocol PKCE code challenge method SHA256
  private static final String codeChallengeMethod = "S256";

  // generated application test client
  private static String scopes = "offine openid read";
  private static String redirectUri = "http://127.0.0.1:9631/callback";

  /*------- const (end) ------- */

  // start docker compose
  @Container
  public static DockerComposeContainer<?> containersDockerCompose = new DockerComposeContainer<>(
      pathToResourceDockerComposeFile)
      // .env docker compose
      .withEnv("USER_DATA_POSTGRESQL_PASSWORD", "superpass")
      .withEnv("HYDRA_POSTGRESQL_PASSWORD", "superpass2")
      .withEnv("HYDRA_SECRETS_COOKIE", "some_cookies111111111111111122222")
      .withEnv("HYDRA_SECRETS_SYSTEM", "some_secrets111111111111111122222")
      .withEnv("HYDRA_DEPENDS_ON_MIGRATE", "service_started")
      // public Ory Hydra
      .withExposedService(hydraContainerDockerCompose, hydraPublicPortDockerCompose,
          Wait.forListeningPort().withStartupTimeout(Duration.ofMinutes(30)))
      // admin Ory Hydra
      .withExposedService(hydraContainerDockerCompose, hydraAdminPortDockerCompose,
          Wait.forHttp("/version").withHeader("X-Forwarded-Proto", "https")
              .withStartupTimeout(Duration.ofMinutes(30)))
      // .yaml v2 <-> v3
      .withOptions("--compatibility")
      // docker-compose local
      .withLocalCompose(true);

  // http client for public Ory Hydra
  private static WebTestClient publicWebTestClient;

  // OAuth 2.0 client Id
  private static String clientId;

  @DynamicPropertySource
  public static void setting(DynamicPropertyRegistry registry) throws UnsupportedEncodingException {

    /* postgresql user */

    registry.add("spring.datasource.driverClassName", () -> "org.postgresql.Driver");
    registry.add("spring.jpa.properties.hibernate.dialect", () -> "org.hibernate.dialect.PostgreSQLDialect");
    registry.add("spring.datasource.url", () -> "1");

    /* Ory Hydra admin */

    var hydraAdminBaseURI = String.format("http://%s:%d/admin/",
        containersDockerCompose.getServiceHost(hydraContainerDockerCompose, hydraAdminPortDockerCompose),
        containersDockerCompose.getServicePort(hydraContainerDockerCompose, hydraAdminPortDockerCompose));

    registry.add("application.ory-hydra.admin.baseURI", () -> hydraAdminBaseURI);

    WebTestClient adminWebTestClient = WebTestClient.bindToServer()
        .baseUrl(hydraAdminBaseURI)
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
        // Since Ory Hydra is configured for TLS termination, the header below is
        // required
        // We pretend that WebClient is a proxy with TLS termination
        // Так как Ory Hydra настроена на TLS termination, то необходим заголовок ниже
        // Делаем вид что, WebClient прокси с TLS termination
        .defaultHeader("X-Forwarded-Proto", "https")
        .build();

    /* Ory Hydra Public */

    var hydraPublicBaseURI = String.format("http://%s:%d/",
        containersDockerCompose.getServiceHost(hydraContainerDockerCompose, hydraPublicPortDockerCompose),
        containersDockerCompose.getServicePort(hydraContainerDockerCompose, hydraPublicPortDockerCompose));

    registry.add("application.ory-hydra.public.baseURI", () -> hydraPublicBaseURI);

    publicWebTestClient = WebTestClient.bindToServer()
        .baseUrl(hydraPublicBaseURI)
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
        // Since Ory Hydra is configured for TLS termination, the header below is
        // required
        // We pretend that WebClient is a proxy with TLS termination
        // Так как Ory Hydra настроена на TLS termination, то необходим заголовок ниже
        // Делаем вид что, WebClient прокси с TLS termination
        .defaultHeader("X-Forwarded-Proto", "https")
        .build();

    // create a test client application
    CreateClientModel createClientModel = new CreateClientModel();
    createClientModel.setRedirect_uris(List.of(redirectUri));
    createClientModel.setGrant_types(List.of("authorization_code"));
    createClientModel.setResponse_types(List.of("code"));
    createClientModel.setScope(scopes);

    adminWebTestClient
        .post()
        .uri("/clients")
        .body(Mono.just(createClientModel), CreateClientModel.class)
        .exchange()
        .expectStatus()
        .isCreated()
        .expectBody(CreateClientModel.class)
        .value(val -> {
          clientId = val.getClient_id();
        });

  }

  @Autowired
  private OryHydraService oryHydraService;

  /* ------- temporary variables (begin) --------- */

  // state для 4.1.1 Authorization Request для grant type Authorization Code Grant
  private String state;
  private String nonce;

  private MultiValueMap<String, String> cookiesBeforeOauth2LoginRedirect;
  private MultiValueMap<String, String> cookiesBeforeOauth2ConsentRedirect;
  private String oauth2AuthenticationSession;

  private String loginLocation;
  private String loginChallenge;
  private String consentChallenge;

  private String redirectConsentLocation;
  private String consentLocation;
  private String redirectForContentVerifier;

  private String logoutLocation;
  private String logoutChallenge;
  private String redirectLogoutLocation;

  private String codeVerifier;
  private String codeChallenge;

  /* ------- temporary variables (end) --------- */

  @BeforeEach
  public void initEach() throws UnsupportedEncodingException, NoSuchAlgorithmException {

    // PKCE
    codeVerifier = SupportModule.generateCodeVerifier();
    codeChallenge = SupportModule.generateCodeChallange(codeVerifier);

    state = SupportModule.generateRandomStr();
    nonce = SupportModule.generateRandomStr();

    cookiesBeforeOauth2LoginRedirect = null;
    cookiesBeforeOauth2ConsentRedirect = null;
    oauth2AuthenticationSession = null;

    loginLocation = null;
    loginChallenge = null;
    consentChallenge = null;

    redirectConsentLocation = null;
    consentLocation = null;
    redirectForContentVerifier = null;

    logoutLocation = null;
    logoutChallenge = null;
    redirectLogoutLocation = null;

  }

  /**
   * <p>
   * Init Ory Hydra Login Flow. Get loginChallenge.
   * </p>
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  private void oryHydraInitLoginFlow() throws URISyntaxException, UnsupportedEncodingException {

    String scopesURI = URLEncoder.encode(String.join(" ", scopes), "UTF-8");

    publicWebTestClient
        .get()
        .uri(uriBuilder -> uriBuilder
            .path("oauth2/auth")
            .queryParam("client_id", clientId)
            .queryParam("response_type", "code")
            .queryParam("state", state)
            .queryParam("nonce", nonce)
            .queryParam("redirect_uri", redirectUri)
            .queryParam("scope", scopesURI)
            // PKCE
            .queryParam(CODE_CHALLENGE, codeChallenge)
            .queryParam(CODE_CHALLENGE_METHOD, codeChallengeMethod)
            .build())
        .cookie(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession == null
            || oauth2AuthenticationSession.isBlank()
            || oauth2AuthenticationSession.isEmpty() ? ""
                : oauth2AuthenticationSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format("^https:\\/\\/%s\\/api\\/login\\?login_challenge=.+$", AUTH_DOMAIN))
        .expectHeader()
        .value("Location", location -> loginLocation = location)
        .expectHeader()
        .exists("Set-Cookie")
        .expectHeader()
        .values("Set-Cookie", cookies -> {
          cookiesBeforeOauth2LoginRedirect = new LinkedMultiValueMap<>(cookies.size());

          for (int i = 0; i < cookies.size(); i++) {
            String nameAndValueCookieStr = cookies.get(i).split(";")[0];

            String[] nameAndValueCookieArray = nameAndValueCookieStr.split("=", 2);

            cookiesBeforeOauth2LoginRedirect.add(nameAndValueCookieArray[0], nameAndValueCookieArray[1]);

          }

        });

    URI loginLocationURI = new URI(loginLocation);
    String queryParamsStr = loginLocationURI.getQuery();

    // check that the request parameters are present
    assertThat(queryParamsStr).isNotEmpty().isNotBlank().contains("=");

    // parse request parameters into a convenient structure
    var queryParams = Arrays
        .stream(queryParamsStr.split("&"))
        .map(SupportModule::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    // check that there is a login_challenge in the request parameters
    assertThat(queryParams).isNotEmpty().containsOnlyKeys(LOGIN_CHALLENGE);

    // remember login_challenge
    loginChallenge = queryParams.get(LOGIN_CHALLENGE).get(0);
  }

  /**
   * <p>
   * Init Ory Hydra Consent Flow. Get loginChallenge.
   * </p>
   *
   * @param queryParamsStrRedirectConsent - query params for init Consent Flow
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  private void oryHydraInitConsentFlow(String queryParamsStrRedirectConsent) throws URISyntaxException {

    publicWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsStrRedirectConsent)
                .build())
        .cookies(cookies -> cookies.addAll(cookiesBeforeOauth2LoginRedirect))
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format("^https:\\/\\/%s\\/api\\/consent\\?consent_challenge=.+$", AUTH_DOMAIN))
        .expectHeader()
        .value("Location", location -> consentLocation = location)
        .expectCookie()
        // remember ora hydra session for re-authentication
        // (authentication without password re-entry)
        // запоминаем сессию ora hydra для переаутентификации
        // (аутентификации без повторного ввода пароля)
        .value(OAUTH2_AUTHENTICATION_SESSION, val -> oauth2AuthenticationSession = val)
        .expectHeader()
        .exists("Set-Cookie")
        .expectHeader()
        .values("Set-Cookie", cookies -> {
          cookiesBeforeOauth2ConsentRedirect = new LinkedMultiValueMap<>(cookies.size());

          for (int i = 0; i < cookies.size(); i++) {
            String nameAndValueCookieStr = cookies.get(i).split(";")[0];

            String[] nameAndValueCookieArray = nameAndValueCookieStr.split("=", 2);

            if (cookiesBeforeOauth2ConsentRedirect.containsKey(nameAndValueCookieArray[0])) {
              cookiesBeforeOauth2ConsentRedirect.remove(nameAndValueCookieArray[0]);
              cookiesBeforeOauth2ConsentRedirect.add(nameAndValueCookieArray[0], nameAndValueCookieArray[1]);
            } else {
              cookiesBeforeOauth2ConsentRedirect.add(nameAndValueCookieArray[0], nameAndValueCookieArray[1]);
            }

          }

        });

    URI consentLocationURI = new URI(consentLocation);
    var queryParamsStrConsent = consentLocationURI.getQuery();

    // check that the request parameters are present
    assertThat(queryParamsStrConsent).isNotEmpty().isNotBlank().contains("=");

    // parse request parameters into a convenient structure
    var queryParamsConsent = Arrays
        .stream(queryParamsStrConsent.split("&"))
        .map(SupportModule::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    // check that there is consent_challenge in the request parameters
    assertThat(queryParamsConsent).isNotEmpty().containsOnlyKeys(CONSENT_CHALLENGE);

    // remember consent_challenge
    consentChallenge = queryParamsConsent.get(CONSENT_CHALLENGE).get(0);
  }

  /**
   * <p>
   * Ory Hydra full Cycle Auth
   * </p>
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  private void fullCycleAuth() throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException {

    // 4.1.1 Authorization Request

    // authentication request
    oryHydraInitLoginFlow();

    /* BEGIN ory hydra login flow */

    // check info loginChallenge
    StepVerifier
        .create(this.oryHydraService.loginRequestInfo(loginChallenge))
        .expectNextMatches(body -> body.getClient().getClientId().equals(clientId))
        .verifyComplete();

    // authorization with redirect
    var acceptLoginRequestModel = Mono.just(
        AcceptLoginRequestModelBuilder.builder()
            .setSubject(login)
            .setRemember(true)
            .setRememberFor(60L * 60L * 24L)
            .setContextModel("")
            .build());
    StepVerifier
        .create(this.oryHydraService.acceptLoginRequest(loginChallenge, acceptLoginRequestModel))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectConsentLocation = responseWithRedirectModel.getRedirectTo();

              return redirectConsentLocation
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/auth\\?client_id=%s&code_challenge=%s&code_challenge_method=%s&login_verifier=.+&response_type=code&scope=.+&state=%s$",
                          AUTH_DOMAIN, clientId, codeChallenge, codeChallengeMethod, state));
            })
        .verifyComplete();

    /* END ory hydra login flow */

    URI redirectConsentLocationURI = new URI(redirectConsentLocation);
    var queryParamsStrRedirectConsent = redirectConsentLocationURI.getQuery();

    // remember the login flow state and switch to ory hydra consent flow
    oryHydraInitConsentFlow(queryParamsStrRedirectConsent);

    /* BEGIN ory hydra consent flow */

    StepVerifier
        .create(this.oryHydraService.consentRequestInfo(consentChallenge))
        .expectNextMatches(body -> body.getClient().getClientId().equals(clientId))
        .verifyComplete();

    TestAccessTokenExtension accessTokenExtension = new TestAccessTokenExtension();
    accessTokenExtension.setId(1L);
    accessTokenExtension.setName("some_name");

    TestIdTokenExtension idTokenExtension = new TestIdTokenExtension();
    idTokenExtension.setHash("some_hash");

    var acceptConsentRequestModelMono = Mono.just(
        AcceptConsentRequestModelBuilder.builder()
            .setGrantScope(Arrays.asList(scopes.split(" ")))
            .setRemember(true)
            .setRememberFor(36L * 60L * 60L)
            .setSession(
                SessionForTokenModelBuilder
                    .builder()
                    .setAccessTokenExtension(accessTokenExtension)
                    .setIdTokenExtension(idTokenExtension)
                    .build())
            .build());

    StepVerifier
        .create(this.oryHydraService.acceptConsentRequest(consentChallenge, acceptConsentRequestModelMono))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectForContentVerifier = responseWithRedirectModel.getRedirectTo();

              return redirectForContentVerifier
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/auth\\?client_id=%s&code_challenge=%s&code_challenge_method=%s&consent_verifier=.+&response_type=code&scope=.+&state=%s$",
                          AUTH_DOMAIN, clientId, codeChallenge, codeChallengeMethod, state));
            })
        .verifyComplete();

    URI redirectForContentVerifierURI = new URI(redirectForContentVerifier);
    var queryParamsForContentVerifier = redirectForContentVerifierURI.getQuery();

    /* END ory hydra consent flow */

    // THE END
    publicWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsForContentVerifier)
                .build())
        .cookies(cookies -> {
          cookies.addAll(cookiesBeforeOauth2ConsentRedirect);
          cookiesBeforeOauth2LoginRedirect.entrySet()
              .removeIf(k -> cookiesBeforeOauth2ConsentRedirect.containsKey(k.getKey()));
          cookies.addAll(cookiesBeforeOauth2LoginRedirect);
          cookies.add(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession);
        })
        .exchange()
        .expectStatus()
        .isSeeOther()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location", String.format("^%s\\?code=.+&scope=.+&state=%s$", redirectUri, state));
  }

  @Test
  @Order(1)
  @DisplayName("Full cycle of user authentication and authorization")
  void fullCycleAuthentication() throws UnsupportedEncodingException, NoSuchAlgorithmException, URISyntaxException {
    fullCycleAuth();
  }

  @Test
  @Order(2)
  @DisplayName("Reject login flow")
  void rejectLoginRequest() throws URISyntaxException, UnsupportedEncodingException {

    // authentication request
    oryHydraInitLoginFlow();

    // error for reject
    var errorModel = ErrorModelBuilder
        .builder()
        .setError("some_error")
        .setErrorDescription("some_description")
        .setStatusCode(504L)
        .setErrorDebug("some_debug")
        .setErrorHint("hint")
        .build();
    var errorModelMono = Mono.just(errorModel);

    StepVerifier
        .create(this.oryHydraService.rejectLoginRequest(loginChallenge, errorModelMono))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectConsentLocation = responseWithRedirectModel.getRedirectTo();

              return redirectConsentLocation
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/auth\\?client_id=%s&code_challenge=%s&code_challenge_method=%s&login_verifier=.+&response_type=code&scope=.+&state=%s$",
                          AUTH_DOMAIN, clientId, codeChallenge, codeChallengeMethod, state));
            })
        .verifyComplete();

    URI redirectConsentLocationURI = new URI(redirectConsentLocation);
    var queryParamsStrRedirectConsent = redirectConsentLocationURI.getQuery();

    publicWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsStrRedirectConsent)
                .build())
        .cookies(cookies -> cookies.addAll(cookiesBeforeOauth2LoginRedirect))
        .exchange()
        .expectStatus()
        .isSeeOther()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location",
            String.format("^%s\\?error=%s&error_description=%s\\+hint&state=%s$",
                redirectUri, errorModel.getError(), errorModel.getErrorDescription(), state));
  }

  @Test
  @Order(3)
  @DisplayName("Reject consent flow")
  void rejectConsentRequest() throws URISyntaxException, UnsupportedEncodingException {

    oryHydraInitLoginFlow();

    /* BEGIN ory hydra login flow */

    var acceptLoginRequestModel = Mono.just(
        AcceptLoginRequestModelBuilder.builder()
            .setSubject(login)
            .setRemember(true)
            .setRememberFor(60L * 60L * 24L)
            .setContextModel("")
            .build());

    StepVerifier
        .create(this.oryHydraService.acceptLoginRequest(loginChallenge, acceptLoginRequestModel))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectConsentLocation = responseWithRedirectModel.getRedirectTo();

              return redirectConsentLocation
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/auth\\?client_id=%s&code_challenge=%s&code_challenge_method=%s&login_verifier=.+&response_type=code&scope=.+&state=%s$",
                          AUTH_DOMAIN, clientId, codeChallenge, codeChallengeMethod, state));
            })
        .verifyComplete();

    /* END ory hydra login flow */

    URI redirectConsentLocationURI = new URI(redirectConsentLocation);
    var queryParamsStrRedirectConsent = redirectConsentLocationURI.getQuery();

    oryHydraInitConsentFlow(queryParamsStrRedirectConsent);

    /* BEGIN ory hydra consent flow */

    var errorModel = ErrorModelBuilder
        .builder()
        .setError("some_error")
        .setErrorDescription("some_description")
        .setStatusCode(504L)
        .build();

    var errorModelMono = Mono.just(errorModel);

    StepVerifier
        .create(this.oryHydraService.rejectConsentRequest(consentChallenge, errorModelMono))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectForContentVerifier = responseWithRedirectModel.getRedirectTo();

              return redirectForContentVerifier
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/auth\\?client_id=%s&code_challenge=%s&code_challenge_method=%s&consent_verifier=.+&response_type=code&scope=.+&state=%s$",
                          AUTH_DOMAIN, clientId, codeChallenge, codeChallengeMethod, state));
            })
        .verifyComplete();

    URI redirectForContentVerifierURI = new URI(redirectForContentVerifier);
    var queryParamsForContentVerifier = redirectForContentVerifierURI.getQuery();

    /* END ory hydra consent flow */

    publicWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("/oauth2/auth")
                .query(queryParamsForContentVerifier)
                .build())
        .cookies(cookies -> {
          cookies.addAll(cookiesBeforeOauth2ConsentRedirect);
          cookiesBeforeOauth2LoginRedirect.entrySet()
              .removeIf(k -> cookiesBeforeOauth2ConsentRedirect.containsKey(k.getKey()));
          cookies.addAll(cookiesBeforeOauth2LoginRedirect);
          cookies.add(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession);
        })
        .exchange()
        .expectStatus()
        .isSeeOther()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location",
            String.format("^%s\\?error=%s&error_description=%s&state=%s$",
                redirectUri, errorModel.getError(), errorModel.getErrorDescription(), state));
  }

  @Test
  @Order(4)
  @DisplayName("Full exit cycle")
  void fullCycleLogout()
      throws URISyntaxException, UnsupportedEncodingException, NoSuchAlgorithmException {

    fullCycleAuth();

    /* BEGIN ory hydra logout flow */

    publicWebTestClient
        .get()
        .uri(uriBuilder -> uriBuilder
            .path("oauth2/sessions/logout")
            .build())
        .cookie(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location",
            String.format("^https:\\/\\/%s\\/api\\/logout\\?logout_challenge=.+$",
                AUTH_DOMAIN))
        .expectHeader()
        .value("Location", location -> logoutLocation = location);

    URI logoutLocationURI = new URI(logoutLocation);
    String queryParamsStr = logoutLocationURI.getQuery();

    var queryParams = Arrays
        .stream(queryParamsStr.split("&"))
        .map(SupportModule::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    logoutChallenge = queryParams.get(LOGOUT_CHALLENGE).get(0);

    StepVerifier
        .create(this.oryHydraService.logoutRequestInfo(logoutChallenge))
        .expectNextMatches(body -> body.getSubject().equals(login))
        .verifyComplete();

    StepVerifier
        .create(this.oryHydraService.acceptLogoutRequest(logoutChallenge))
        .expectNextMatches(
            responseWithRedirectModel -> {

              redirectLogoutLocation = responseWithRedirectModel.getRedirectTo();

              return redirectLogoutLocation
                  .matches(
                      String.format(
                          "^https:\\/\\/%s\\/oauth2\\/sessions\\/logout\\?logout_verifier=.+$",
                          AUTH_DOMAIN));
            })
        .verifyComplete();

    URI redirectForLogoutVerifierURI = new URI(redirectLogoutLocation);
    var queryParamsForLogoutVerifier = redirectForLogoutVerifierURI.getQuery();

    publicWebTestClient
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/sessions/logout")
                .query(queryParamsForLogoutVerifier)
                .build())
        .cookie(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location",
            String.format("^https:\\/\\/%s\\/logout\\/success$",
                AUTH_DOMAIN));

    /* END ory hydra logout flow */
  }

  @Test
  @Order(5)
  @DisplayName("reject Logout Flow")
  void rejectLogoutRequest()
      throws URISyntaxException, UnsupportedEncodingException, NoSuchAlgorithmException {

    fullCycleAuth();

    /* BEGIN ory hydra logout flow */

    publicWebTestClient
        .get()
        .uri(uriBuilder -> uriBuilder
            .path("oauth2/sessions/logout")
            .build())
        .cookie(OAUTH2_AUTHENTICATION_SESSION, oauth2AuthenticationSession)
        .exchange()
        .expectStatus()
        .isFound()
        .expectHeader()
        .exists("Location")
        .expectHeader()
        .valueMatches("Location",
            String.format("^https:\\/\\/%s\\/api\\/logout\\?logout_challenge=.+$",
                AUTH_DOMAIN))
        .expectHeader()
        .value("Location", location -> logoutLocation = location);

    URI logoutLocationURI = new URI(logoutLocation);
    String queryParamsStr = logoutLocationURI.getQuery();

    var queryParams = Arrays
        .stream(queryParamsStr.split("&"))
        .map(SupportModule::splitQueryParameter)
        .collect(
            Collectors.groupingBy(
                SimpleImmutableEntry::getKey,
                LinkedHashMap::new,
                Collectors.mapping(Map.Entry::getValue,
                    Collectors.toList())));

    logoutChallenge = queryParams.get(LOGOUT_CHALLENGE).get(0);

    StepVerifier
        .create(this.oryHydraService.logoutRequestInfo(logoutChallenge))
        .expectNextMatches(body -> body.getSubject().equals(login))
        .verifyComplete();

    StepVerifier
        .create(this.oryHydraService.rejectLogoutRequest(logoutChallenge))
        .verifyComplete();

    /* END ory hydra logout flow */
  }

}
