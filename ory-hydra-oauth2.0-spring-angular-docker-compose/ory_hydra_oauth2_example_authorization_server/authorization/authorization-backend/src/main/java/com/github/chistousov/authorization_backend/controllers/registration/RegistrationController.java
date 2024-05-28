package com.github.chistousov.authorization_backend.controllers.registration;

import javax.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.github.chistousov.authorization_backend.models.PostRegistrationModel;
import com.github.chistousov.authorization_backend.services.UserService;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Controller
@RequestMapping("/registration")
@Slf4j
public class RegistrationController {

  private UserService userService;

  public RegistrationController(UserService userService) {
    this.userService = userService;
  }

  @PostMapping
  public Mono<ResponseEntity<Long>> postRegistration(@Valid @RequestBody PostRegistrationModel postRegistrationModel) {

    return this.userService
        .createUser(postRegistrationModel)
        .map(idUser -> ResponseEntity
            .status(HttpStatus.CREATED)
            .body(idUser))
        .doOnSuccess(el -> log.info("User is created. "));
  }

}
