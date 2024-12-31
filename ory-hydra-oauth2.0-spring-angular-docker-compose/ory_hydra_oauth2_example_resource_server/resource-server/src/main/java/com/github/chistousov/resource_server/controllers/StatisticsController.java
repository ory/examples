package com.github.chistousov.resource_server.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.chistousov.resource_server.models.Point;
import com.github.chistousov.resource_server.services.PointService;

import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;

@Controller
@RequestMapping("/statistics")
@Slf4j
public class StatisticsController {

  private PointService pointService;

  public StatisticsController(PointService pointService) {
    this.pointService = pointService;
  }

  @Operation(summary = "Get statistics")
  @GetMapping
  @ResponseBody
  public Flux<Point> getStatistics() {
    return this.pointService
        .getPoints()
        .doOnComplete(() -> log.info("Response: get points "));
  }
}
