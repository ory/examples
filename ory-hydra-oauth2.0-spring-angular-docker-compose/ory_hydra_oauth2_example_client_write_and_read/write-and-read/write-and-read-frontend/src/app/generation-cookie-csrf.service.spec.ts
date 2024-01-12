import { TestBed } from '@angular/core/testing';

import { GenerationCookieCsrfService } from './generation-cookie-csrf.service';
import { CookieService } from './cookie.service';

describe('GenerationCookieCsrfService', () => {
  let service: GenerationCookieCsrfService;
  let cookieServiceSpy: jasmine.SpyObj<CookieService>;

  beforeEach(() => {

    TestBed.configureTestingModule({
      providers: [
        GenerationCookieCsrfService,
        {
          provide: CookieService, useValue: jasmine.createSpyObj('CookieService', ['setCookie'])
        }
      ]
    });
    service = TestBed.inject(GenerationCookieCsrfService);
    cookieServiceSpy = TestBed.inject(CookieService) as jasmine.SpyObj<CookieService>;
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('generateCookieCsrf', () => {
    // given (instead of when)

    const expectedCookieName = service.xsrfTokenCookieName;
    
    let actualCookieName: string = '';
    let actualCookieValue: string = ''; 
    cookieServiceSpy.setCookie.and.callFake( (name, value, options) => {
      actualCookieName = name;
      actualCookieValue = value;
    })

    // when

    service.generateCookieCsrf();

    // then (instead of verify)

    expect(cookieServiceSpy.setCookie.calls.count())
      .toBe(1);
    expect(actualCookieName).toEqual(expectedCookieName);
    expect(actualCookieValue).toBeTruthy();
  });
});