import { ComponentFixture, TestBed, fakeAsync, tick, waitForAsync } from '@angular/core/testing';

import { LineChartComponent } from './line-chart.component';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { AppService } from '../app.service';
import { Point } from '../models/point.model';
import { last, lastValueFrom, of } from 'rxjs';

describe('LineChartComponent', () => {
  let component: LineChartComponent;
  let fixture: ComponentFixture<LineChartComponent>;
  let appServiceSpy: jasmine.SpyObj<AppService>;

  let points: Point[] = [
    {
      x: 1,
      y: 1
    },
    {
      x: 2,
      y: 2
    },
    {
      x: 3,
      y: 3
    }
  ];

  let x: number[] = points.map((value) => value.x);
  let y: number[] = points.map((value) => value.y);

  beforeEach(async () => {

    await TestBed.configureTestingModule({
      imports: [LineChartComponent] ,
        providers: [
          {
            provide: AppService, useValue: jasmine.createSpyObj('AppService', ['getData'])
          }
        ]
      })
        .compileComponents();

    });


    beforeEach(() => {

      appServiceSpy = TestBed.inject(AppService) as jasmine.SpyObj<AppService>;

      appServiceSpy.getData.and.returnValue(of(points));

      fixture = TestBed.createComponent(LineChartComponent);
      component = fixture.componentInstance;
      fixture.detectChanges();

    });

    it('should create', (done: DoneFn) => {
      expect(component).toBeTruthy();

      component.lineChartData$
        .subscribe({
          next: lineChartData => {
            expect(lineChartData.datasets.length).toEqual(1);
            expect(lineChartData.datasets[0].data).toEqual(x);
            expect(lineChartData.labels).toEqual(y);
            done();
          },
          error: er => done.fail('not error')
        });
    });


});
