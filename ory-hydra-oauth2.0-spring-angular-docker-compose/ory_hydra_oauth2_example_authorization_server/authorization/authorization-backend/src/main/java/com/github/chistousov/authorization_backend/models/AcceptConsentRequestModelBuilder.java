package com.github.chistousov.authorization_backend.models;

import java.util.List;

import lombok.Getter;

@Getter
public class AcceptConsentRequestModelBuilder {
  private Boolean remember;
  private SessionForTokenModel session;
  private List<String> grantScope;
  private Long rememberFor;

  public static AcceptConsentRequestModelBuilder builder() {
    return new AcceptConsentRequestModelBuilder();
  }

  private AcceptConsentRequestModelBuilder() {
  }

  public AcceptConsentRequestModelBuilder setRemember(Boolean remember) {
    this.remember = remember;
    return this;
  }

  public AcceptConsentRequestModelBuilder setSession(SessionForTokenModel session) {
    this.session = session;
    return this;
  }

  public AcceptConsentRequestModelBuilder setGrantScope(List<String> grantScope) {
    this.grantScope = grantScope;
    return this;
  }

  public AcceptConsentRequestModelBuilder setRememberFor(Long rememberFor) {
    this.rememberFor = rememberFor;
    return this;
  }

  public Boolean getRemember() {
    return remember;
  }

  public AcceptConsentRequestModel build() {
    return new AcceptConsentRequestModel(this);
  }
}
