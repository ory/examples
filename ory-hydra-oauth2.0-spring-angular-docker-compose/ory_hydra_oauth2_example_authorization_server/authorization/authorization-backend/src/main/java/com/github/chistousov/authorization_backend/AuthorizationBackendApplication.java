package com.github.chistousov.authorization_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.chistousov.authorization_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

@SpringBootApplication
@ExcludeFromJacocoGeneratedReport
public class AuthorizationBackendApplication {

  public static void main(String[] args) {
    SpringApplication.run(AuthorizationBackendApplication.class, args);
  }

}
