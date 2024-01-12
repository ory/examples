package com.github.chistousov.authorization_backend.dao.exception_translators;

import javax.persistence.PersistenceException;

import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.support.PersistenceExceptionTranslator;
import org.springframework.lang.Nullable;

import com.github.chistousov.authorization_backend.exceptions.relational_database.LoginOrOrgExistException;
import com.github.chistousov.authorization_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

@ExcludeFromJacocoGeneratedReport
public class CustomPersistenceExceptionTranslator implements PersistenceExceptionTranslator {

  @Override
  @Nullable
  public DataAccessException translateExceptionIfPossible(RuntimeException ex) {
    if (ex instanceof PersistenceException
        &&
        ((PersistenceException) ex).getCause() instanceof ConstraintViolationException) {

      var persistenceException = (PersistenceException) ex;
      var constraintViolationException = (ConstraintViolationException) persistenceException.getCause();

      String sql = constraintViolationException.getSQL();

      if (sql.equals("horns_and_hooves.add_user")) {
        return new LoginOrOrgExistException("The login or organization exists! ");
      }
    }
    return null;
  }

}
