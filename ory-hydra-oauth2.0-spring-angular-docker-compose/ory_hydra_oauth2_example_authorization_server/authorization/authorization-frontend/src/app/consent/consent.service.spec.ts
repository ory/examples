import { TestBed } from '@angular/core/testing';

import { ConsentService } from './consent.service';
import { ErrorService } from '../error.service';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { environment } from '../../environments/environment';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { HttpErrorResponse, HttpParams } from '@angular/common/http';

describe('ConsentService', () => {
  let service: ConsentService;
  let errorServiceSpy: jasmine.SpyObj<ErrorService>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [ HttpClientTestingModule ],
      providers: [
        ConsentService,
        {
          provide: ErrorService, useValue: jasmine.createSpyObj('ErrorService', ['handle'])
        }
      ]
    });
    service = TestBed.inject(ConsentService);
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

  
  it('clientName', (done: DoneFn) => {
    // given (instead of when)

    const consentClientNameHttpURL = `${environment.apiUrl}/consent/client-name`;

    const clientNameFoo = 'Foo';

    // when

    service.clientName()
      .subscribe({
        next: clientN => {
          expect(clientN).toEqual(clientNameFoo);
          done();
        },
        error: er => done.fail('clientName is expected') 
      });
    
    const req = httpTestingController.expectOne(consentClientNameHttpURL);
    req.flush(clientNameFoo);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');
  });

  it('subject', (done: DoneFn) => {
    // given (instead of when)

    const subjectClientNameHttpURL = `${environment.apiUrl}/consent/subject`;

    const subject = 'qwerty';

    // when

    service.subject()
      .subscribe({
        next: sub => {
          expect(sub).toEqual(subject);
          done();
        },
        error: er => done.fail('subject is expected') 
      });
    
    const req = httpTestingController.expectOne(subjectClientNameHttpURL);
    req.flush(subject);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');
  });

  it('scopes', (done: DoneFn) => {
    // given (instead of when)

    const scopesHttpURL = `${environment.apiUrl}/consent/scopes`;
    
    const scopes: string[] = ['read', 'write'];
    
    // when

    service.scopes()
      .subscribe({
        next: scops => {
          expect(scops).toEqual(scopes);
          done();
        },
        error: er => done.fail('scopes is expected') 
      });
    
    const req = httpTestingController.expectOne(scopesHttpURL);
    req.flush(scopes);

    // then (instead of verify)

    expect(req.request.method).toEqual('GET');
  });

  it('consentSuccess', (done: DoneFn) => {
    // given (instead of when)

    const consentSuccessHttpURL = `${environment.apiUrl}/consent`;

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "some_redirect"
    };

    // when

    service.consentSuccess()
      .subscribe({
        next: responseWithRedirectModelLocal => {
          expect(responseWithRedirectModelLocal).toEqual(responseWithRedirectModel);
          done();
        },
        error: er => done.fail('responseWithRedirectModelLocal is expected') 
      });
    
    const req = httpTestingController.expectOne(consentSuccessHttpURL);
    req.flush(responseWithRedirectModel);

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');
  });

  
  it('consentSuccess', (done: DoneFn) => {
    // given (instead of when)

    const consentSuccessHttpURL = `${environment.apiUrl}/consent?is-remember=true`;

    let params = new HttpParams();
    params = params.append('is-remember', true);

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "some_redirect"
    };

    // when

    service.consentSuccess(true)
      .subscribe({
        next: responseWithRedirectModelLocal => {
          expect(responseWithRedirectModelLocal).toEqual(responseWithRedirectModel);
          done();
        },
        error: er => done.fail('responseWithRedirectModelLocal is expected') 
      });
    
    const req = httpTestingController.expectOne(consentSuccessHttpURL);
    req.flush(responseWithRedirectModel);

    // then (instead of verify)

    expect(req.request.method).toEqual('PUT');
    expect(req.request.params.has("is-remember")).toEqual(true);
    expect(req.request.params.get("is-remember")).toEqual('true');
  });


  it('consentCancel', (done: DoneFn) => {
    // given (instead of when)

    const consentCancelHttpURL = `${environment.apiUrl}/consent/cancel`;

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "some_redirect"
    };

    // when

    service.consentCancel()
      .subscribe({
        next: responseWithRedirectModelLocal => {
          expect(responseWithRedirectModelLocal).toEqual(responseWithRedirectModel);
          done();
        },
        error: er => done.fail('responseWithRedirectModelLocal is expected') 
      });
    
    const req = httpTestingController.expectOne(consentCancelHttpURL);
    req.flush(responseWithRedirectModel);

    // then (instead of verify)

    expect(req.request.method).toEqual('DELETE');
  });

  it('consentCancel should be fail', done => {
    // given (instead of when)

    const consentCancelHttpURL = `${environment.apiUrl}/consent/cancel`;

    const expectedErrorResponse = new HttpErrorResponse({
      error: '["password is invalid"]',
      url: consentCancelHttpURL,
      status: 400, 
      statusText: 'Bad request'
    });

    // when

    service.consentCancel()
      .subscribe({
        next: responseWithRedirectModelLocal => done.fail('consentCancel not expected'),
        error: (actualErrorResponse: HttpErrorResponse) => {
          expect(actualErrorResponse).toEqual(expectedErrorResponse);
          done();
        }
      });


    const req = httpTestingController.expectOne(consentCancelHttpURL);
    
    req.flush(expectedErrorResponse.error, expectedErrorResponse);

    // then (instead of verify)

    expect(req.request.method).toEqual('DELETE');

    expect(errorServiceSpy.handle.calls.count())
    .toBe(1);
    expect(errorServiceSpy.handle.calls.first().args)
      .toEqual([ expectedErrorResponse.error ]);
  });
});
