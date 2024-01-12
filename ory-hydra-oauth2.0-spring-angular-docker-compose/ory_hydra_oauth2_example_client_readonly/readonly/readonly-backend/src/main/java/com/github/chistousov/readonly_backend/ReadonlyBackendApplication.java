package com.github.chistousov.readonly_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.chistousov.readonly_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

@SpringBootApplication
@ExcludeFromJacocoGeneratedReport
public class ReadonlyBackendApplication {

  public static void main(String[] args) {
    SpringApplication.run(ReadonlyBackendApplication.class, args);
  }

}
