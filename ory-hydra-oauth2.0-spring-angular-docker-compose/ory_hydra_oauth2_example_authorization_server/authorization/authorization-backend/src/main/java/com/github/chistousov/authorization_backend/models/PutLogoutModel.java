package com.github.chistousov.authorization_backend.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PutLogoutModel {
  private Boolean isConfirmed;
}
