package com.github.chistousov.resource_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.chistousov.resource_server.jacoco_ignore.ExcludeFromJacocoGeneratedReport;

@SpringBootApplication
@ExcludeFromJacocoGeneratedReport
public class ResourceServerApplication {

  public static void main(String[] args) {
    SpringApplication.run(ResourceServerApplication.class, args);
  }

}
