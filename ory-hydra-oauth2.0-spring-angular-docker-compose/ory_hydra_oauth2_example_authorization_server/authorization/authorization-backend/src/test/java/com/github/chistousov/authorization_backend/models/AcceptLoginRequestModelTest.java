package com.github.chistousov.authorization_backend.models;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.catchThrowable;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

public class AcceptLoginRequestModelTest {

  @Test
  @DisplayName("AcceptLoginRequestModel: subject is null")
  void testConstructorAcceptLoginRequestModel1() {
    // given (instead of when)

    // when

    Throwable thrown = catchThrowable(() -> AcceptLoginRequestModelBuilder
        .builder()
        .setSubject(null)
        .build());

    // then (instead of verify)

    assertThat(thrown).hasMessageContaining("Subject not set");

  }

  @Test
  @DisplayName("AcceptLoginRequestModel: subject is blank")
  void testConstructorAcceptLoginRequestModel2() {
    // given (instead of when)

    // when

    Throwable thrown = catchThrowable(() -> AcceptLoginRequestModelBuilder
        .builder()
        .setSubject("")
        .build());

    // then (instead of verify)

    assertThat(thrown).hasMessageContaining("Subject not set");
  }
}
