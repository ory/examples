package com.github.chistousov.authorization_backend.models;

import lombok.Getter;

@Getter
public class ErrorModelBuilder {
  private String error;
  private String errorDebug;
  private String errorDescription;
  private String errorHint;
  private Long statusCode;

  public static ErrorModelBuilder builder() {
    return new ErrorModelBuilder();
  }

  private ErrorModelBuilder() {
  }

  public ErrorModelBuilder setError(String error) {
    this.error = error;
    return this;
  }

  public ErrorModelBuilder setErrorDebug(String errorDebug) {
    this.errorDebug = errorDebug;
    return this;
  }

  public ErrorModelBuilder setErrorDescription(String errorDescription) {
    this.errorDescription = errorDescription;
    return this;
  }

  public ErrorModelBuilder setErrorHint(String errorHint) {
    this.errorHint = errorHint;
    return this;
  }

  public ErrorModelBuilder setStatusCode(Long statusCode) {
    this.statusCode = statusCode;
    return this;
  }

  public ErrorModel build() {
    return new ErrorModel(this);
  }

}
