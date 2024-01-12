import { TestBed } from '@angular/core/testing';

import { LogoutService } from './logout.service';
import { ErrorService } from './error.service';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../environments/environment';
import { ResponseWithRedirectModel } from './models/response-with-redirect.model';
import { HttpErrorResponse } from '@angular/common/http';

describe('LogoutService', () => {
  let service: LogoutService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {

    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [
        LogoutService,
        {
          provide: ErrorService, useValue: jasmine.createSpyObj('ErrorService', ['handle'])
        }
      ]
    });
    service = TestBed.inject(LogoutService);
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

  it('logoutSendResponse - confirm', done => {
    // given (instead of when)

    const logoutSendResponseHttpURL = `${environment.apiUrl}/logout/`;

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };

    const logoutSendResponseModel = {
      "isConfirmed": true
    };

    // when

    service.logoutSendResponse(logoutSendResponseModel.isConfirmed)
      .subscribe({
        next: responseWithRedirectModelLocal => {
          expect(responseWithRedirectModelLocal).toEqual(responseWithRedirectModel);
          done();
        },
        error: er => done.fail('responseWithRedirectModelLocal is expected') 
      });

    const req = httpTestingController.expectOne(logoutSendResponseHttpURL);
    req.flush(responseWithRedirectModel);

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');
    expect(req.request.body).toEqual(logoutSendResponseModel);

  });

  it('logoutSendResponse should be fail', done => {
    // given (instead of when)

    const logoutSendResponseHttpURL = `${environment.apiUrl}/logout/`;

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: logoutSendResponseHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    const logoutSendResponseModel = {
      "isConfirmed": true
    };

    // when

    service.logoutSendResponse(logoutSendResponseModel.isConfirmed)
      .subscribe({
        next: responseWithRedirectModelLocal => done.fail('data not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(logoutSendResponseHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');
    expect(req.request.body).toEqual(logoutSendResponseModel);

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });

});
