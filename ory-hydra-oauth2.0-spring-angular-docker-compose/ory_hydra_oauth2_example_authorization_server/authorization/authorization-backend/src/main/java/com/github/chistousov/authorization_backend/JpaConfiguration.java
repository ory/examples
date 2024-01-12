package com.github.chistousov.authorization_backend;

import java.util.concurrent.Executors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.support.PersistenceExceptionTranslator;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import com.github.chistousov.authorization_backend.dao.exception_translators.CustomPersistenceExceptionTranslator;

import reactor.core.scheduler.Scheduler;
import reactor.core.scheduler.Schedulers;

@Configuration
public class JpaConfiguration {

  @Value("${spring.datasource.hikari.maximum-pool-size}")
  private int connectionPoolSize;

  /**
   * <p>
   * To create a thread pool for an asynchronous call to stored procedures by the
   * number of connection pool
   * </p>
   *
   * <p>
   * Для создания пула потоков для асинхроного вызова хранимым процедур по
   * количеству пула подключений
   * </p>
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  @Bean
  public Scheduler jdbcScheduler() {
    return Schedulers.fromExecutor(Executors.newFixedThreadPool(connectionPoolSize));
  }

  /**
   * <p>
   * To manually create a transaction
   * </p>
   *
   * <p>
   * Для ручного создания транзакции
   * </p>
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */
  @Bean
  public TransactionTemplate transactionTemplate(PlatformTransactionManager transactionManager) {
    return new TransactionTemplate(transactionManager);
  }

  /**
   * <p>
   * Maps errors from the database to specific exceptions
   * </p>
   *
   * <p>
   * Отображает ошибки с БД в определенные исключения
   * </p>
   *
   * @author Nikita Chistousov (chistousov.nik@yandex.ru)
   * @since 11
   */

  @Bean
  public PersistenceExceptionTranslator customPersistenceExceptionTranslator() {
    return new CustomPersistenceExceptionTranslator();
  }

}
