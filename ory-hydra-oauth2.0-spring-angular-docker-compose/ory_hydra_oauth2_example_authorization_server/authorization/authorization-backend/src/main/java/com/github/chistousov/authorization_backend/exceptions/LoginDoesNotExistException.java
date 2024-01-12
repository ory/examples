package com.github.chistousov.authorization_backend.exceptions;

public class LoginDoesNotExistException extends RuntimeException {

  public LoginDoesNotExistException(String message) {
    super(message);
  }
}
