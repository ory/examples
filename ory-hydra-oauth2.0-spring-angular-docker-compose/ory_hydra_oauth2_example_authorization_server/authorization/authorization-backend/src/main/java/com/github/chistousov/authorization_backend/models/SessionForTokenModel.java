package com.github.chistousov.authorization_backend.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;

@Getter
@JsonIgnoreProperties(ignoreUnknown = true)
public class SessionForTokenModel {

  @JsonProperty("access_token")
  private Object accessTokenExtension;

  @JsonProperty("id_token")
  private Object idTokenExtension;

  public SessionForTokenModel(SessionForTokenModelBuilder builder) {
    this.accessTokenExtension = builder.getAccessTokenExtension();
    this.idTokenExtension = builder.getIdTokenExtension();
  }

}
