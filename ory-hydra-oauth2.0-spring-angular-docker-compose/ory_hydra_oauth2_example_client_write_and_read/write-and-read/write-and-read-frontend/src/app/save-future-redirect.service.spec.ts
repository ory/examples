import { TestBed } from '@angular/core/testing';

import { SaveFutureRedirectService } from './save-future-redirect.service';
import { CookieService } from './cookie.service';
import { Router, provideRouter } from '@angular/router';
import { routes } from './app.routes';

describe('SaveFutureRedirectService', () => {
  let service: SaveFutureRedirectService;
  let cookieServiceSpy: jasmine.SpyObj<CookieService>;
  let router: jasmine.SpyObj<Router>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        {
          provide: CookieService, useValue: jasmine.createSpyObj('CookieService', ['setCookie', 'getCookie', 'deleteCookie'])
        },
        {
          provide: Router, useValue: jasmine.createSpyObj('Router', ['navigateByUrl'])
        },
      ]
    });
    service = TestBed.inject(SaveFutureRedirectService);
    cookieServiceSpy = TestBed.inject(CookieService) as jasmine.SpyObj<CookieService>;

    router = TestBed.inject(Router) as jasmine.SpyObj<Router>;

  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('saveIfNotExist', () => {
    // given (instead of when)

    const expectedCookieName = service.urlCookieName;
    
    let actualCookieName: string = 'n';
    let actualCookieValue: string = 'v'; 
    
    cookieServiceSpy.getCookie.and.returnValue(undefined);
    
    cookieServiceSpy.setCookie.and.callFake( (name, value, options) => {
      actualCookieName = name;
      actualCookieValue = value;
    })

    // when 

    service.saveIfNotExist();

    // then (instead of verify)

    expect(cookieServiceSpy.getCookie.calls.count())
      .toBe(1);
    expect(cookieServiceSpy.setCookie.calls.count())
      .toBe(1);
    expect(actualCookieName).toEqual(expectedCookieName);

  });

  it('redirectAndClearIfExist', () => {
    // given (instead of when)

    const url: string = 'some_url';

    cookieServiceSpy.getCookie.and.returnValue(url);
    
    // when

    service.redirectAndClearIfExist();

    // then (instead of verify)

    expect(cookieServiceSpy.getCookie.calls.count())
      .toBe(1);
    expect(cookieServiceSpy.deleteCookie.calls.count())
      .toBe(1);
    
    expect(router.navigateByUrl.calls.count())
      .toBe(1);

  });
});
