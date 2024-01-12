package com.github.chistousov.authorization_backend.models;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class GetConsentResponseModel {

  private String acr;

  private List<String> amr;

  private String challenge;

  private Client client;

  private Object context;

  @JsonProperty("login_challenge")
  private String loginChallenge;

  @JsonProperty("login_session_id")
  private String loginSessionId;

  @JsonProperty("oidc_context")
  private Object oidcContext;

  @JsonProperty("request_url")
  private String requestUrl;

  @JsonProperty("requested_access_token_audience")
  private List<String> requestedAccessTokenAudience;

  @JsonProperty("requested_scope")
  private List<String> requestedScope;

  private Boolean skip;

  private String subject;
}
