package com.github.chistousov.authorization_backend.services;

import java.util.Objects;

import org.springframework.core.env.Environment;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.github.chistousov.authorization_backend.models.AcceptConsentRequestModel;
import com.github.chistousov.authorization_backend.models.AcceptLoginRequestModel;
import com.github.chistousov.authorization_backend.models.ErrorModel;
import com.github.chistousov.authorization_backend.models.GetConsentResponseModel;
import com.github.chistousov.authorization_backend.models.GetLoginResponseModel;
import com.github.chistousov.authorization_backend.models.GetLogoutResponseModel;
import com.github.chistousov.authorization_backend.models.ResponseWithRedirectModel;

import reactor.core.publisher.Mono;

/**
 * <p>
 * Service for working with admin Ory Hydra
 * </p>
 *
 * @author Nikita Chistousov (chistousov.nik@yandex.ru)
 * @since 11
 */
@Service
public class OryHydraService {
  private static final String LOGIN_CHALLENGE = "login_challenge";
  private static final String CONSENT_CHALLENGE = "consent_challenge";
  private static final String LOGOUT_CHALLENGE = "logout_challenge";

  private WebClient oryHydraAdminEndPoint;

  public OryHydraService(Environment env) {

    this.oryHydraAdminEndPoint = WebClient
        .builder()
        .baseUrl(Objects.requireNonNull(env.getProperty("application.ory-hydra.admin.baseURI")))
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)

        // Since Ory Hydra is configured for TLS termination, the header below is
        // required
        // We pretend that WebClient is a proxy with TLS termination

        // Так как Ory Hydra настроена на TLS termination, то необходим заголовок ниже
        // Делаем вид что, WebClient прокси с TLS termination

        .defaultHeader("X-Forwarded-Proto", "https")
        .build();
  }

  /**
   * <p>
   * check whether the user was authenticated before and remembered himself in the
   * system?
   * plus we also get information about the client
   * </p>
   *
   * <p>
   * проверяем аутентифицировался ли раньше пользователь и запомнил себя в
   * системе?
   * плюс так же получаем информацию о клиенте
   * </p>
   *
   * @param loginChallenge - login processing unique ID
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<GetLoginResponseModel> loginRequestInfo(String loginChallenge) {
    return this.oryHydraAdminEndPoint
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/login")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
                .build())
        .retrieve()
        .bodyToMono(GetLoginResponseModel.class);
  }

  /**
   * <p>
   * accept authentication of a specific user
   * </p>
   *
   * <p>
   * принимаем аутентификацию определенного пользователя
   * </p>
   *
   * @param loginChallenge          - login processing unique ID
   * @param acceptLoginRequestModel - authentication data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> acceptLoginRequest(String loginChallenge,
      Mono<AcceptLoginRequestModel> acceptLoginRequestModel) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/login/accept")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
                .build())
        .body(acceptLoginRequestModel, AcceptLoginRequestModel.class)
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

  /**
   * <p>
   * deny authentication of a specific user
   * </p>
   *
   * <p>
   * отклоняем аутентификацию определенного пользователя
   * </p>
   *
   * @param loginChallenge          - login processing unique ID
   * @param rejectLoginRequestModel - error data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> rejectLoginRequest(String loginChallenge,
      Mono<ErrorModel> rejectLoginRequestModel) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/login/reject")
                .queryParam(LOGIN_CHALLENGE, loginChallenge)
                .build())
        .body(rejectLoginRequestModel, ErrorModel.class)
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

  /**
   * <p>
   * check whether the scope check has started in the system?
   * plus we also get information about the client
   * </p>
   *
   * <p>
   * проверяем начали ли проверку scope
   * в системе?
   * плюс так же получаем информацию о клиенте
   * </p>
   *
   * @param consentChallenge - scope processing unique identifier
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<GetConsentResponseModel> consentRequestInfo(String consentChallenge) {
    return this.oryHydraAdminEndPoint
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/consent")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .retrieve()
        .bodyToMono(GetConsentResponseModel.class);
  }

  /**
   * <p>
   * accept scopes of a specific user
   * </p>
   *
   * <p>
   * принимаем scopes определенного пользователя
   * </p>
   *
   * @param consentChallenge          - scope processing unique identifier
   * @param acceptConsentRequestModel - scope data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> acceptConsentRequest(String consentChallenge,
      Mono<AcceptConsentRequestModel> acceptConsentRequestModel) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/consent/accept")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .body(acceptConsentRequestModel, AcceptConsentRequestModel.class)
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

  /**
   * <p>
   * deny authentication of a specific user
   * </p>
   *
   * <p>
   * отклоняем аутентификацию определенного пользователя
   * </p>
   *
   * @param consentChallenge          - login processing unique ID
   * @param rejectConsentRequestModel - error data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> rejectConsentRequest(String consentChallenge,
      Mono<ErrorModel> rejectConsentRequestModel) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/consent/reject")
                .queryParam(CONSENT_CHALLENGE, consentChallenge)
                .build())
        .body(rejectConsentRequestModel, ErrorModel.class)
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

  /**
   * <p>
   * Getting information by logout
   * </p>
   *
   * <p>
   * Получаем информацию по logout
   * </p>
   *
   * @param logoutChallenge - exit handling unique identifier
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<GetLogoutResponseModel> logoutRequestInfo(String logoutChallenge) {
    return this.oryHydraAdminEndPoint
        .get()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/logout")
                .queryParam(LOGOUT_CHALLENGE, logoutChallenge)
                .build())
        .retrieve()
        .bodyToMono(GetLogoutResponseModel.class);
  }

  /**
   * <p>
   * confirm logout
   * </p>
   *
   * <p>
   * подтверждаем logout
   * </p>
   *
   * @param logoutChallenge - logout processing unique identifier
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> acceptLogoutRequest(String logoutChallenge) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/logout/accept")
                .queryParam(LOGOUT_CHALLENGE, logoutChallenge)
                .build())
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

  /**
   * <p>
   * deny logout request
   * </p>
   *
   * <p>
   * отклонить запрос на logout
   * </p>
   *
   * @param logoutChallenge - exit handling unique identifier
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<ResponseWithRedirectModel> rejectLogoutRequest(String logoutChallenge) {
    return this.oryHydraAdminEndPoint
        .put()
        .uri(
            uriBuilder -> uriBuilder
                .path("oauth2/auth/requests/logout/reject")
                .queryParam(LOGOUT_CHALLENGE, logoutChallenge)
                .build())
        .retrieve()
        .bodyToMono(ResponseWithRedirectModel.class);
  }

}
