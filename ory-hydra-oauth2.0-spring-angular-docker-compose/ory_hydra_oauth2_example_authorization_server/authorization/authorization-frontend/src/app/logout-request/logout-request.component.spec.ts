import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';

import { LogoutRequestComponent } from './logout-request.component';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { LogoutService } from '../logout.service';
import { WindowService } from '../window.service';
import { DebugElement } from '@angular/core';
import { By } from '@angular/platform-browser';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { of, throwError } from 'rxjs';
import { HttpErrorResponse } from '@angular/common/http';
import { CookieService } from '../cookie.service';

describe('LogoutRequestComponent', () => {
  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let logoutServiceSpy: jasmine.SpyObj<LogoutService>;
  let windowServiceSpy: jasmine.SpyObj<WindowService>;
  let cookieServiceSpy: jasmine.SpyObj<CookieService>;

  let component: LogoutRequestComponent;
  let fixture: ComponentFixture<LogoutRequestComponent>;

  let hostDe: DebugElement;

  let yesButton: HTMLButtonElement;
  let noButton: HTMLButtonElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LogoutRequestComponent],
      providers: [
        {
          provide: GenerationCookieCsrfService,
          useValue: jasmine.createSpyObj('GenerationCookieCsrfService', ['generateCookieCsrf'])
        },
        {
          provide: LogoutService,
          useValue: jasmine.createSpyObj('LogoutService', ['logoutSendResponse'])
        },
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        },
        {
          provide: CookieService, useValue: jasmine.createSpyObj('CookieService', ['setCookie'])
        }
      ]
    })
      .compileComponents()
      .then(async () => {
        generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
        logoutServiceSpy = TestBed.inject(LogoutService) as jasmine.SpyObj<LogoutService>;
        windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;
        cookieServiceSpy = TestBed.inject(CookieService) as jasmine.SpyObj<CookieService>;

        fixture = TestBed.createComponent(LogoutRequestComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();

        hostDe = fixture.debugElement;

        yesButton = hostDe.query(By.css("#yesButton")).nativeElement;
        noButton = hostDe.query(By.css("#noButton")).nativeElement;

      });

  });


  it('yes (GUI)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    logoutServiceSpy.logoutSendResponse.and.returnValue(of(responseWithRedirectModel));

    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);
    // when

    yesButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(logoutServiceSpy.logoutSendResponse.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(logoutServiceSpy.logoutSendResponse.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${true} ]`)
      .toEqual([true]);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);

    expect(cookieServiceSpy.setCookie.calls.count())
      .withContext("cookieServiceSpy.setCookie.calls.count() !== 1")
      .toBe(1);
    expect(cookieServiceSpy.setCookie.calls.first().args)
      .withContext(`cookieServiceSpy.setCookie.calls.first().args != ["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      } ]`)
      .toEqual(["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      }]);


  }));


  it('(enter)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    logoutServiceSpy.logoutSendResponse.and.returnValue(of(responseWithRedirectModel));

    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    // when

    // enter
    window.dispatchEvent(new KeyboardEvent('keydown', {
      key: 'enter',
    }));
    fixture.detectChanges();

    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(logoutServiceSpy.logoutSendResponse.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(logoutServiceSpy.logoutSendResponse.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${true} ]`)
      .toEqual([true]);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);

    expect(cookieServiceSpy.setCookie.calls.count())
      .withContext("cookieServiceSpy.setCookie.calls.count() !== 1")
      .toBe(1);
    expect(cookieServiceSpy.setCookie.calls.first().args)
      .withContext(`cookieServiceSpy.setCookie.calls.first().args != ["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      } ]`)
      .toEqual(["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      }]);
  }));



  it('(esc)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    logoutServiceSpy.logoutSendResponse.and.returnValue(of(responseWithRedirectModel));

    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    // when

    // enter
    window.dispatchEvent(new KeyboardEvent('keydown', {
      key: 'Escape',
    }));
    fixture.detectChanges();

    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(logoutServiceSpy.logoutSendResponse.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(logoutServiceSpy.logoutSendResponse.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${false} ]`)
      .toEqual([false]);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);

    expect(cookieServiceSpy.setCookie.calls.count())
      .withContext("cookieServiceSpy.setCookie.calls.count() !== 1")
      .toBe(1);
    expect(cookieServiceSpy.setCookie.calls.first().args)
      .withContext(`cookieServiceSpy.setCookie.calls.first().args != ["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      } ]`)
      .toEqual(["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      }]);
  }));


  it('yse (GUI) (fail)', fakeAsync(() => {
    // given (instead of when)

    logoutServiceSpy.logoutSendResponse.and.returnValue(throwError(() => new HttpErrorResponse({ status: 404 })));
    // when

    yesButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(logoutServiceSpy.logoutSendResponse.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);

    expect(cookieServiceSpy.setCookie.calls.count())
      .withContext("cookieServiceSpy.setCookie.calls.count() !== 1")
      .toBe(1);
    expect(cookieServiceSpy.setCookie.calls.first().args)
      .withContext(`cookieServiceSpy.setCookie.calls.first().args != ["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      } ]`)
      .toEqual(["logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      }]);

  }));


});
