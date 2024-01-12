package com.github.chistousov.authorization_backend.exceptions;

public class IncorrectPasswordException extends RuntimeException {

  public IncorrectPasswordException(String message) {
    super(message);
  }
}
