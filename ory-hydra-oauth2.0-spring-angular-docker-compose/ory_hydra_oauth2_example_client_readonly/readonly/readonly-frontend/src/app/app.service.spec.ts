import { TestBed } from '@angular/core/testing';

import { AppService } from './app.service';

import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { Point } from './models/point.model';
import { environment } from '../environments/environment';
import { ErrorService } from './error.service';
import { HttpErrorResponse } from '@angular/common/http';

describe('AppService', () => {
  let service: AppService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

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

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [ HttpClientTestingModule ],
      providers: [
        {
          provide: ErrorService, useValue: jasmine.createSpyObj('ErrorService', ['handle'])
        }
      ]
    });
    service = TestBed.inject(AppService);
    errorServiceSpy = TestBed.inject(ErrorService) as jasmine.SpyObj<ErrorService>;
    httpTestingController = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    // After every test, assert that there are no more pending requests.
    httpTestingController.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('getData', (done: DoneFn) => {
    // given (instead of when)

    const dataHttpURL = `${environment.apiUrl}/data`;

    // when

    service.getData()
      .subscribe({
        next: ps => {
          expect(ps).toEqual(points);
          done();
        },
        error: er => done.fail('data is expected') 
      });
    
    const req = httpTestingController.expectOne(dataHttpURL);
    req.flush(points);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');
  });

  it('getData (fail)', done => {
    // given (instead of when)

    const dataHttpURL = `${environment.apiUrl}/data`;

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: dataHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    // when

    service.getData()
      .subscribe({
        next: ps => done.fail('change not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(dataHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });

});
