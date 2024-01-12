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
public class GetLoginResponseModel {

  private String challenge;

  private Client client;

  @JsonProperty("oidc_context")
  private Object oidcContext;

  @JsonProperty("request_url")
  private String requestUrl;

  @JsonProperty("requested_access_token_audience")
  private List<String> requestedAccessTokenAudience;

  @JsonProperty("requested_scope")
  private List<String> requestedScope;

  @JsonProperty("session_id")
  private String sessionId;

  private Boolean skip;

  private String subject;
}
