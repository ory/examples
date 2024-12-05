package com.github.chistousov.write_and_read_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.chistousov.write_and_read_backend.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

@SpringBootApplication
@ExcludeFromJacocoGeneratedReport
public class WriteAndReadBackendApplication {

  public static void main(String[] args) {
    SpringApplication.run(WriteAndReadBackendApplication.class, args);
  }

}
