package com.github.chistousov.authorization_backend.models;

import java.util.Objects;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.chistousov.authorization_backend.exceptions.AcceptLoginRequestModelException;

import lombok.EqualsAndHashCode;
import lombok.Getter;

@Getter
@EqualsAndHashCode(of = { "subject" })
@JsonIgnoreProperties(ignoreUnknown = true)
public class AcceptLoginRequestModel {
  private String subject;

  private Boolean remember;

  @JsonProperty("remember_for")
  private Long rememberFor;

  private Object context;

  public AcceptLoginRequestModel(AcceptLoginRequestModelBuilder acceptLoginRequestModelBuilder) {
    if (Objects.isNull(acceptLoginRequestModelBuilder.getSubject())
        || acceptLoginRequestModelBuilder.getSubject().isBlank()) {
      throw new AcceptLoginRequestModelException("Subject not set");
    }

    this.subject = acceptLoginRequestModelBuilder.getSubject();
    this.remember = acceptLoginRequestModelBuilder.getRemember();
    this.rememberFor = acceptLoginRequestModelBuilder.getRememberFor();
    this.context = acceptLoginRequestModelBuilder.getContextModel();
  }
}
