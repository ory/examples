import { TestBed } from '@angular/core/testing';

import { LoginService } from './login.service';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { ErrorService } from '../error.service';
import { HttpErrorResponse } from '@angular/common/http';

describe('LoginService', () => {
  let service: LoginService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [ HttpClientTestingModule ],
      providers: [
        LoginService,
        {
          provide: ErrorService, useValue: jasmine.createSpyObj('ErrorService', ['handle'])
        }
      ]
    });
    service = TestBed.inject(LoginService);
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

  it('login should be success', (done: DoneFn) => {
    // given (instead of when)

    const loginHttpURL = `${environment.apiUrl}/login`;

    const loginModel = {
      "login": "some_login",
      "password": "some_password",
      "isRemember": true
    };

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "some_redirect"
    };

    // when

    service.login(loginModel.login, loginModel.password, loginModel.isRemember)
      .subscribe({
        next: responseWithRedirectModelLocal => {
          expect(responseWithRedirectModelLocal).toEqual(responseWithRedirectModel);
          done();
        },
        error: er => done.fail('responseWithRedirectModelLocal is expected') 
      });
    
    const req = httpTestingController.expectOne(loginHttpURL);
    req.flush(responseWithRedirectModel);

    // then (instead of verify)

    expect(req.request.method).toEqual('POST');
    expect(req.request.body).toEqual(loginModel);
  });

  it('login should be fail', done => {
    // given (instead of when)

    const loginHttpURL = `${environment.apiUrl}/login`;

    const loginModel = {
      "login": "some_login",
      "password": "some_password",
      "isRemember": true
    };

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: loginHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    // when

    service.login(loginModel.login, loginModel.password, loginModel.isRemember)
      .subscribe({
        next: responseWithRedirectModelLocal => done.fail('login not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(loginHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('POST');
    expect(req.request.body).toEqual(loginModel);

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });

});
