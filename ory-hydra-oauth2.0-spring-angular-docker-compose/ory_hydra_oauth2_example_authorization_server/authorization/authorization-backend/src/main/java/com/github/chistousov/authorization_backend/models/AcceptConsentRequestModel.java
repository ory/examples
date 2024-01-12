package com.github.chistousov.authorization_backend.models;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;

@Getter
@JsonIgnoreProperties(ignoreUnknown = true)
public class AcceptConsentRequestModel {

  private Boolean remember;

  private SessionForTokenModel session;

  @JsonProperty("grant_scope")
  private List<String> grantScope;

  @JsonProperty("remember_for")
  private Long rememberFor;

  public AcceptConsentRequestModel(AcceptConsentRequestModelBuilder builder) {
    this.remember = builder.getRemember();
    this.session = builder.getSession();
    this.grantScope = builder.getGrantScope();
    this.rememberFor = builder.getRememberFor();
  }

}
