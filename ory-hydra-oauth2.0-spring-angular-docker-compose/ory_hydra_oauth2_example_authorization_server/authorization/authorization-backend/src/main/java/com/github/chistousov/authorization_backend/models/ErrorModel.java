package com.github.chistousov.authorization_backend.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;

@Getter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ErrorModel {
  private String error;

  @JsonProperty("error_debug")
  private String errorDebug;

  @JsonProperty("error_description")
  private String errorDescription;

  @JsonProperty("error_hint")
  private String errorHint;

  @JsonProperty("status_code")
  private Long statusCode;

  public ErrorModel(ErrorModelBuilder builder) {
    this.error = builder.getError();
    this.errorDebug = builder.getErrorDebug();
    this.errorDescription = builder.getErrorDescription();
    this.errorHint = builder.getErrorHint();
    this.statusCode = builder.getStatusCode();
  }

}
