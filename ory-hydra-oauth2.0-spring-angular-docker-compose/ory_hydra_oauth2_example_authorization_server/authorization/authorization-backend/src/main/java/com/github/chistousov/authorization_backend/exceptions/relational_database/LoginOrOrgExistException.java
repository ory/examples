package com.github.chistousov.authorization_backend.exceptions.relational_database;

import org.springframework.dao.DataAccessException;

public class LoginOrOrgExistException extends DataAccessException {

  public LoginOrOrgExistException(String message) {
    super(message);
  }
}
