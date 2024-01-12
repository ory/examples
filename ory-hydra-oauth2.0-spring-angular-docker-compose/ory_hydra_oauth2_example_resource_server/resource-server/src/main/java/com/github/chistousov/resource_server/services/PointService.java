package com.github.chistousov.resource_server.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.github.chistousov.resource_server.jacoco_ignore.ExcludeFromJacocoGeneratedReport;
import com.github.chistousov.resource_server.models.Point;

import reactor.core.publisher.Flux;

@Service
@ExcludeFromJacocoGeneratedReport
public class PointService {

  private List<Point> points;

  private double nextX;

  private Random random = new Random();

  public PointService() {

    this.points = new ArrayList<>();
    this.points.add(new Point(1, 2.3));
    this.points.add(new Point(2, 1.7));
    this.points.add(new Point(3, 5.4));
    this.points.add(new Point(4, 6.8));
    this.points.add(new Point(5, 4.2));
    this.points.add(new Point(6, 3.6));

    this.nextX = 7 + (2 * random.nextDouble());

  }

  public Flux<Point> getPoints() {
    return Flux.fromIterable(points);
  }

  public void calculateNewPoint() {
    points.add(new Point(nextX, 20 * random.nextDouble()));
    nextX += 2 * random.nextDouble();
  }

}
