import { TestBed } from '@angular/core/testing';

import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { HttpErrorResponse } from '@angular/common/http';

import { RegistrationService } from './registration.service';
import { ErrorService } from '../error.service';
import { environment } from '../../environments/environment';

describe('RegistrationService', () => {
  let service: RegistrationService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {

    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [
        RegistrationService,
        {
          provide: ErrorService, useValue: jasmine.createSpyObj('ErrorService', ['handle'])
        }
      ]
    });
    service = TestBed.inject(RegistrationService);
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

  it('registration should be succeed', done => {
    // given (instead of when)

    const registrationHttpBody: {
      login: string,
      password: string,
      orgName: string
    } = {
      login: "someLogin",
      password: "4Jof0#@V4cTaFev0",
      orgName: "someOrg"
    };

    const expectedUserId: number = 641;

    // when

    service.registration(registrationHttpBody.login, registrationHttpBody.password, registrationHttpBody.orgName)
      .subscribe({
        next: actualUserId => {
          expect(actualUserId).toEqual(expectedUserId);
          done();
        },
        error: done.fail
      });

    const req = httpTestingController.expectOne(`${environment.apiUrl}/registration`);

    req.flush(expectedUserId);

    // then (instead of verify)

    expect(req.request.method).toEqual('POST');
    expect(req.request.body).toEqual(registrationHttpBody);

  });

  it('registration should be fail', done => {
    // given (instead of when)

    const registrationHttpURL = `${environment.apiUrl}/registration`;

    const registrationHttpBody: {
      login: string,
      password: string,
      orgName: string
    } = {
      login: "someLogin",
      password: "xxx",
      orgName: "someOrg"
    };

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: registrationHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    // when

    service.registration(registrationHttpBody.login, registrationHttpBody.password, registrationHttpBody.orgName)
      .subscribe({
        next: actualUserId => done.fail('data not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(registrationHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('POST');
    expect(req.request.body).toEqual(registrationHttpBody);

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });

});
