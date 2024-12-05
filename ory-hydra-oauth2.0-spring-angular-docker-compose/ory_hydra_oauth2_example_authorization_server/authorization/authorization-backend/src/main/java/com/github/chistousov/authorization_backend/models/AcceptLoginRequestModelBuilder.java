package com.github.chistousov.authorization_backend.models;

import lombok.Getter;

@Getter
public class AcceptLoginRequestModelBuilder {

  private String subject;
  private Boolean remember;
  private Long rememberFor;
  private Object contextModel;

  public static AcceptLoginRequestModelBuilder builder() {
    return new AcceptLoginRequestModelBuilder();
  }

  private AcceptLoginRequestModelBuilder() {
  }

  public AcceptLoginRequestModelBuilder setRemember(Boolean remember) {
    this.remember = remember;
    return this;
  }

  public AcceptLoginRequestModelBuilder setRememberFor(Long rememberFor) {
    this.rememberFor = rememberFor;
    return this;
  }

  public AcceptLoginRequestModelBuilder setSubject(String subject) {
    this.subject = subject;
    return this;
  }

  public AcceptLoginRequestModelBuilder setContextModel(Object contextModel) {
    this.contextModel = contextModel;
    return this;
  }

  public AcceptLoginRequestModel build() {
    return new AcceptLoginRequestModel(this);
  }

}
