package com.github.chistousov.authorization_backend.services;

import java.util.List;
import java.util.function.Supplier;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import com.github.chistousov.authorization_backend.dao.entities.User;
import com.github.chistousov.authorization_backend.dao.repositories.UserRepository;
import com.github.chistousov.authorization_backend.exceptions.IncorrectPasswordException;
import com.github.chistousov.authorization_backend.exceptions.LoginDoesNotExistException;
import com.github.chistousov.authorization_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;
import com.github.chistousov.authorization_backend.models.PostRegistrationModel;

import reactor.core.publisher.Mono;
import reactor.core.scheduler.Scheduler;

/**
 * <p>
 * Service for working with the user (creation and verification)
 * </p>
 *
 * @author Nikita Chistousov (chistousov.nik@yandex.ru)
 * @since 11
 */
@Service
public class UserService {

  private TransactionTemplate transactionTemplate;
  private Scheduler jdbcScheduler;

  private UserRepository userRepository;
  private PasswordEncoder passwordEncoder;

  @PersistenceContext
  private EntityManager em;

  public UserService(UserRepository userRepository, PasswordEncoder passwordEncoderRegister) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoderRegister;
  }

  @Autowired
  public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
    this.transactionTemplate = transactionTemplate;
  }

  @Autowired
  @Qualifier("jdbcScheduler")
  public void setJdbcScheduler(Scheduler jdbcScheduler) {
    this.jdbcScheduler = jdbcScheduler;
  }

  /**
   *
   * <p>
   * Create a user
   * </p>
   *
   *
   * @param postRegistrationModel - registration data
   *
   * @return user id
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<Long> createUser(PostRegistrationModel postRegistrationModel) {

    return Mono.fromCallable(
        () -> {

          String hashPassword = passwordEncoder.encode(postRegistrationModel.getPassword());

          return transaction(() -> userRepository.createUser(
              postRegistrationModel.getLogin(),
              hashPassword,
              postRegistrationModel.getOrgName()));
        })
        .subscribeOn(jdbcScheduler);

  }

  /**
   *
   * <p>
   * Get user by login and check user
   * </p>
   *
   *
   * @param login    - login
   *
   * @param password - password
   *
   * @return user data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<User> getUserAndCheck(String login, String password) {

    return Mono.fromCallable(() -> {

      User user = getUserInDB(login);

      if (passwordEncoder.matches(password, user.getPassword())) {
        user.setPassword("");

        return user;
      } else {
        throw new IncorrectPasswordException("Password is incorrect! ");
      }
    })
        .subscribeOn(jdbcScheduler);
  }

  /**
   *
   * <p>
   * Get user by login
   * </p>
   *
   *
   * @param login - login
   *
   * @return user data
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  public Mono<User> getUser(String login) {

    return Mono.fromCallable(() -> {

      User user = getUserInDB(login);
      user.setPassword("");
      return user;

    })
        .subscribeOn(jdbcScheduler);
  }

  private User getUserInDB(String login) {
    return transaction(() -> {

      var storedProcedure = em.createNamedStoredProcedureQuery("User.getUserByLogin");
      storedProcedure.setParameter(2, login);
      storedProcedure.execute();

      List<User> users = (List<User>) storedProcedure.getResultList();

      if (!users.isEmpty()) {
        return users.get(0);
      } else {
        throw new LoginDoesNotExistException("login does not exist");
      }

    });
  }

  /**
   * <p>
   * Additional wrapper for manual transaction to be ignored in JaCoCo
   * </p>
   *
   * @param manId - user in the system
   *
   * @return user information
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  @ExcludeFromJacocoGeneratedReport
  private <T> T transaction(Supplier<T> s) {
    return transactionTemplate.execute(status -> s.get());
  }
}
