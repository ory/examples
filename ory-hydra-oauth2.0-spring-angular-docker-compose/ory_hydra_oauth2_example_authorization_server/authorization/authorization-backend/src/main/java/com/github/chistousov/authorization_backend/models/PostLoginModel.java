package com.github.chistousov.authorization_backend.models;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PostLoginModel {

  @NotBlank(message = "login is blank")
  @Size(min = 4, message = "login must be greater than 4")
  private String login;

  @NotBlank(message = "password is blank")
  @Pattern(regexp = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$", message = "password is invalid")
  private String password;

  private Boolean isRemember;
}
