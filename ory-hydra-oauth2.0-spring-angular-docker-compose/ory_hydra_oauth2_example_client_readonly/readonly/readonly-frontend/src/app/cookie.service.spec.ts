import { TestBed } from '@angular/core/testing';

import { CookieService } from './cookie.service';

describe('CookieService', () => {
  let service: CookieService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        CookieService
      ]
    });
    service = TestBed.inject(CookieService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('setCookie, getCookie and deleteCookie', () => {
    // given (instead of when)

    const expectedNotExistCookieValue: string | undefined = undefined;

    const expectedSomeCookie = {
      name: 'myCookieName',
      value: 'myCookieValue',
      options: {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax',
        expires: new Date((new Date()).getTime() + 1)
      }
    };

    const expectedSomeCookie2 = {
      name: 'myCookieName2',
      value: 'myCookieValue2'
    };

    // when

    const actualNotExistCookieValue = service.getCookie('notExistCookie');
    
    service.setCookie(expectedSomeCookie.name, expectedSomeCookie.value, expectedSomeCookie.options);
    const actualSomeCookieValue = service.getCookie(expectedSomeCookie.name);

    service.setCookie(expectedSomeCookie2.name, expectedSomeCookie2.value);
    service.deleteCookie(expectedSomeCookie2.name);
    const actualSomeCookieValue2 = service.getCookie(expectedSomeCookie2.name);

    // then (instead of verify)

    expect(actualNotExistCookieValue).toEqual(expectedNotExistCookieValue);
    expect(actualSomeCookieValue).toEqual(expectedSomeCookie.value);
    expect(actualSomeCookieValue2).toEqual(expectedNotExistCookieValue);

  })
});
