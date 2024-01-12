import { TestBed } from '@angular/core/testing';

import { AppService } from './app.service';

import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../environments/environment';
import { HttpErrorResponse } from '@angular/common/http';
import { ErrorService } from './error.service';

describe('AppService', () => {
  let service: AppService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

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

  it('change', (done: DoneFn) => {
    // given (instead of when)

    const changeHttpURL = `${environment.apiUrl}/change`;

    // when

    service.change()
      .subscribe({
        next: ps => done(),
        error: er => done.fail('change is expected') 
      });
    
    const req = httpTestingController.expectOne(changeHttpURL);
    req.flush({});

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');
  });

  it('change (fail)', done => {
    // given (instead of when)

    const changeHttpURL = `${environment.apiUrl}/change`;

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: changeHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    // when

    service.change()
      .subscribe({
        next: ps => done.fail('change not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(changeHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });

});
