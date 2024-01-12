import { TestBed } from '@angular/core/testing';

import { AuthService } from './auth.service';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { Observable, of } from 'rxjs';
import { environment } from '../environments/environment';
import { HttpErrorResponse } from '@angular/common/http';

describe('AuthService', () => {
  let service: AuthService;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [ HttpClientTestingModule ]
    });
    service = TestBed.inject(AuthService);
    httpTestingController = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    // After every test, assert that there are no more pending requests.
    httpTestingController.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('checkAuthenticate should be succeed', done => {
    // given (instead of when)

    // when

    service.checkAuthenticate()
      .subscribe({
        next: () => {
          done()
        },
        error: done.fail
      });

    const req = httpTestingController.expectOne(`${environment.apiUrl}/logged-in`);

    req.flush(null);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');

  });

  it('checkAuthenticate should be fail', done => {
    // given (instead of when)

    const registrationHttpURL = `${environment.apiUrl}/logged-in`;

    const expectedErrorResponse = new HttpErrorResponse({
      error: '{"redirect_to":"/testtest"}',
      url: registrationHttpURL,
      status: 401, 
      statusText: 'Bad request'
    });


    // when

    service.checkAuthenticate()
      .subscribe({
        next: () => done.fail('data not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });

    const req = httpTestingController.expectOne(registrationHttpURL);

    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');

  });

  it('logout should be succeed', done => {
    // given (instead of when)

    // when

    service.logout()
      .subscribe({
        next: () => {
          done()
        },
        error: done.fail
      });

    const req = httpTestingController.expectOne(`${environment.apiUrl}/logout`);

    req.flush(null);

    // then (instead of verify)

    expect(req.request.method).toEqual('POST');

  });


});