package com.github.chistousov.authorization_backend.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class Client {

  @JsonProperty("allowed_cors_origins")
  private List<String> allowedCorsOrigins;

  private List<String> audience;

  @JsonProperty("authorization_code_grant_access_token_lifespan")
  private String authorizationCodeGrantAccessTokenLifespan;

  @JsonProperty("authorization_code_grant_id_token_lifespan")
  private String authorizationCodeGrantIdTokenLifespan;

  @JsonProperty("authorization_code_grant_refresh_token_lifespan")
  private String authorizationCodeGrantRefreshTokenLifespan;

  @JsonProperty("backchannel_logout_session_required")
  private boolean backchannelLogoutSessionRequired;

  @JsonProperty("backchannel_logout_uri")
  private String backchannelLogoutUri;

  @JsonProperty("client_credentials_grant_access_token_lifespan")
  private String clientCredentialsGrantAccessTokenLifespan;

  @JsonProperty("client_id")
  private String clientId;

  @JsonProperty("client_name")
  private String clientName;

  @JsonProperty("client_secret")
  private String clientSecret;

  @JsonProperty("client_secret_expires_at")
  private int clientSecretExpiresAt;

  @JsonProperty("client_uri")
  private String clientUri;

  private List<String> contacts;

  @JsonProperty("created_at")
  private String createdAt;

  @JsonProperty("frontchannel_logout_session_required")
  private boolean frontchannelLogoutSessionRequired;

  @JsonProperty("frontchannel_logout_uri")
  private String frontchannelLogoutUri;

  @JsonProperty("grant_types")
  private List<String> grantTypes;

  @JsonProperty("implicit_grant_access_token_lifespan")
  private String implicitGrantAccessTokenLifespan;

  @JsonProperty("implicit_grant_id_token_lifespan")
  private String implicitGrantIdTokenLifespan;

  private Object jwks;

  @JsonProperty("jwks_uri")
  private String jwksUri;

  @JsonProperty("jwt_bearer_grant_access_token_lifespan")
  private String jwtBearerGrantAccessTokenLifespan;

  @JsonProperty("logo_uri")
  private String logoUri;

  private Object metadata;

  private String owner;

  @JsonProperty("password_grant_access_token_lifespan")
  private String passwordGrantAccessTokenLifespan;

  @JsonProperty("password_grant_refresh_token_lifespan")
  private String passwordGrantRefreshTokenLifespan;

  @JsonProperty("policy_uri")
  private String policyUri;

  @JsonProperty("post_logout_redirect_uris")
  private List<String> postLogoutRedirectUris;

  @JsonProperty("redirect_uris")
  private List<String> redirectUris;

  @JsonProperty("refresh_token_grant_access_token_lifespan")
  private String refreshTokenGrantAccessTokenLifespan;

  @JsonProperty("refresh_token_grant_id_token_lifespan")
  private String refreshTokenGrantIdTokenLifespan;

  @JsonProperty("refresh_token_grant_refresh_token_lifespan")
  private String refreshTokenGrantRefreshTokenLifespan;

  @JsonProperty("registration_access_token")
  private String registrationAccessToken;

  @JsonProperty("registration_client_uri")
  private String registrationClientUri;

  @JsonProperty("request_object_signing_alg")
  private String requestObjectSigningAlg;

  @JsonProperty("request_uris")
  private List<String> requestUris;

  @JsonProperty("response_types")
  private List<String> responseTypes;

  private String scope;

  @JsonProperty("sector_identifier_uri")
  private String sectorIdentifierUri;

  @JsonProperty("skip_consent")
  private Boolean skipConsent;

  @JsonProperty("subject_type")
  private String subjectType;

  @JsonProperty("token_endpoint_auth_method")
  private String tokenEndpointAuthMethod;

  @JsonProperty("token_endpoint_auth_signing_alg")
  private String tokenEndpointAuthSigningAlg;

  @JsonProperty("tos_uri")
  private String tosUri;

  @JsonProperty("updated_at")
  private String updatedAt;

  @JsonProperty("userinfo_signed_response_alg")
  private String userinfoSignedResponseAlg;
}
