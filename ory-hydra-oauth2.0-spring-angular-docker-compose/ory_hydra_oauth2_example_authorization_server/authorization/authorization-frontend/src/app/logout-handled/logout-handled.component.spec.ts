import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { WindowService } from '../window.service';
import { LogoutHandledComponent } from './logout-handled.component';

import { RouterTestingHarness } from '@angular/router/testing';
import { CookieService } from '../cookie.service';

describe('LogoutHandledComponent', () => {

  let harness: RouterTestingHarness;

  let windowServiceSpy: jasmine.SpyObj<WindowService>;

  let cookieServiceSpy: jasmine.SpyObj<CookieService>;

  beforeEach(async () => {

    await TestBed.configureTestingModule({
      imports: [LogoutHandledComponent],
      providers: [
        provideRouter([
          {
            path: "logout/:status",
            component: LogoutHandledComponent
          },
        ]),
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        },
        {
          provide: CookieService, useValue: jasmine.createSpyObj('CookieService', ['getCookie', 'deleteCookie'])
        }
      ]
    })
      .compileComponents()
      .then(async () => {
        harness = await RouterTestingHarness.create();

        windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;

        cookieServiceSpy = TestBed.inject(CookieService) as jasmine.SpyObj<CookieService>;
      });
  });


  it('logout/success', done => {
    // given (instead of when)

    const windowObj = {
      "history": {
        "go": (amount: number) => { }
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    cookieServiceSpy.getCookie.and.returnValue(undefined);

    // when
    harness.navigateByUrl(`/logout/success`, LogoutHandledComponent)
      .then(comp => {
        expect(comp).toBeTruthy();

        expect(cookieServiceSpy.getCookie.calls.count())
          .withContext("cookieServiceSpy.getCookie.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.getCookie.calls.first().args)
          .withContext(`cookieServiceSpy.getCookie.calls.first().args != ["logout" ]`)
          .toEqual(["logout"]);

        comp.isConfirmed$
          .subscribe({
            next: flag => {
              expect(flag).toEqual(true);
              done();
            },
            error: (er) => done.fail("isConfirmed is incorrect")
          });

      })
      .catch(er => done.fail("isConfirmed is incorrect")
      )

    // then (instead of verify)

  });


  it('logout/ffff', done => {
    // given (instead of when)

    const windowObj = {
      "history": {
        "go": (amount: number) => { }
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    cookieServiceSpy.getCookie.and.returnValue("sss");

    // when
    harness.navigateByUrl(`/logout/ffff`, LogoutHandledComponent)
      .then(comp => {
        expect(comp).toBeTruthy();

        expect(windowServiceSpy.get.calls.count())
          .withContext("windowServiceSpy.get.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.getCookie.calls.count())
          .withContext("cookieServiceSpy.getCookie.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.getCookie.calls.first().args)
          .withContext(`cookieServiceSpy.getCookie.calls.first().args != ["logout" ]`)
          .toEqual(["logout"]);

        comp.isConfirmed$
          .subscribe({
            next: flag => {
              expect(flag).toEqual(false);
              done();
            },
            error: (er) => done.fail("isConfirmed is incorrect")
          });

      })
      .catch(er => done.fail("isConfirmed is incorrect")
      )

    // then (instead of verify)

  });


  it('logout/cancel', done => {
    // given (instead of when)

    const windowObj = {
      "history": {
        "go": (amount: number) => { }
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    cookieServiceSpy.getCookie.and.returnValue("logout");

    // when
    harness.navigateByUrl(`/logout/cancel`, LogoutHandledComponent)
      .then(comp => {
        expect(comp).toBeTruthy();

        expect(windowServiceSpy.get.calls.count())
          .withContext("windowServiceSpy.get.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.getCookie.calls.count())
          .withContext("cookieServiceSpy.getCookie.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.getCookie.calls.first().args)
          .withContext(`cookieServiceSpy.getCookie.calls.first().args != ["logout" ]`)
          .toEqual(["logout"]);

        expect(cookieServiceSpy.deleteCookie.calls.count())
          .withContext("cookieServiceSpy.deleteCookie.calls.count() !== 1")
          .toBe(1);

        expect(cookieServiceSpy.deleteCookie.calls.first().args)
          .withContext(`cookieServiceSpy.deleteCookie.calls.first().args != ["logout" ]`)
          .toEqual(["logout"]);

        comp.isConfirmed$
          .subscribe({
            next: flag => {
              expect(flag).toEqual(false);
              done();
            },
            error: (er) => done.fail("isConfirmed is incorrect")
          });

      })
      .catch(er => done.fail("isConfirmed is incorrect")
      )

    // then (instead of verify)

  });


});
