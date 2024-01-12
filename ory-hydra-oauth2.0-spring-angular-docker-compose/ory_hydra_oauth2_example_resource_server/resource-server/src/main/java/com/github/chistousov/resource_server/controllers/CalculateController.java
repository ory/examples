package com.github.chistousov.resource_server.controllers;

import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.chistousov.resource_server.services.PointService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/calculate")
@Slf4j
public class CalculateController {

  private PointService pointService;

  public CalculateController(PointService pointService) {
    this.pointService = pointService;
  }

  @Operation(summary = "Some calculate")
  @PutMapping
  public void calculate() {
    this.pointService.calculateNewPoint();
    log.info("calculate new point");
  }
}
