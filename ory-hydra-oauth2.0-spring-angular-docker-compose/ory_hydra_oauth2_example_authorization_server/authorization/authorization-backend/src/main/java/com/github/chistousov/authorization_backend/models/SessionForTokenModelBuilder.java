package com.github.chistousov.authorization_backend.models;

import lombok.Getter;

@Getter
public class SessionForTokenModelBuilder {

  private Object accessTokenExtension;

  private Object idTokenExtension;

  public static SessionForTokenModelBuilder builder() {
    return new SessionForTokenModelBuilder();
  }

  private SessionForTokenModelBuilder() {
  }

  public SessionForTokenModelBuilder setAccessTokenExtension(Object accessTokenExtension) {
    this.accessTokenExtension = accessTokenExtension;
    return this;
  }

  public SessionForTokenModelBuilder setIdTokenExtension(Object idTokenExtension) {
    this.idTokenExtension = idTokenExtension;
    return this;
  }

  public SessionForTokenModel build() {
    return new SessionForTokenModel(this);
  }

}
