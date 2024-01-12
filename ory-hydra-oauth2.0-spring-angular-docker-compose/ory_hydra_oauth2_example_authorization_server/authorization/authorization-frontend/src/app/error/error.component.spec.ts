import { ComponentFixture, TestBed, fakeAsync } from '@angular/core/testing';

import { RouterTestingHarness } from '@angular/router/testing';

import { ErrorComponent } from './error.component';
import { ErrorOnPageModel } from '../models/error-on-page.model';
import { ErrorResponseCode } from '../models/error-response-code.model';
import { By } from '@angular/platform-browser';
import { provideRouter } from '@angular/router';
import { WindowService } from '../window.service';

describe('ErrorComponent', () => {

  let harness: RouterTestingHarness;

  let error: string = '111';
  let error_description: string = '222';
  let reauthentication_location: string = '/qqq';

  let windowServiceSpy: jasmine.SpyObj<WindowService>;

  beforeEach(async () => {

    await TestBed.configureTestingModule({
      imports: [ErrorComponent],
      providers: [
        provideRouter([
          {
            path: 'error',
            component: ErrorComponent
          }
        ]),
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        },
      ]
    })
      .compileComponents()
      .then(async () => {
        harness = await RouterTestingHarness.create();
        
        windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;
        
      });
  });

  it('should create', done => {
    harness.navigateByUrl(`/error`, ErrorComponent)
      .then(comp => {
        expect(comp).toBeTruthy();

        comp
          .errorOnPageModel$
          .subscribe(
            {
              next: el => {

                expect(`Неизвестная ошибка`).toEqual(el.error);
                expect("Неизвестное описание").toEqual(el.errorDescription);
                expect('/').toEqual(el.reauthenticationLocation);

                done();
              },
              error: er => done.fail("errorOnPageModel is incorrect")
            });
      });

  });

  it('should create with query param', done => {

    harness.navigateByUrl(`/error?error=${error}&error_description=${error_description}&reauthentication_location=${reauthentication_location}`, ErrorComponent)
      .then(compWithQueryParam => {
        //when
        expect(compWithQueryParam).toBeTruthy();

        compWithQueryParam
          .errorOnPageModel$
          .subscribe(
            {
              next: el => {

                expect(`Ошибка (${error})`).toEqual(el.error);
                expect(error_description).toEqual(el.errorDescription);
                expect(reauthentication_location).toEqual(el.reauthenticationLocation);

                done();
              },
              error: er => done.fail("errorOnPageModel is incorrect")
            }
          );

      });

  });

  it('getErrorResponseCodeRus', async () => {

    // given (instead of when)
    await harness.navigateByUrl(`/error`, ErrorComponent);
    harness.detectChanges();

    let h2 = harness.routeDebugElement!.query(By.css("h2")).nativeElement as HTMLParagraphElement;

    // when
    expect(h2.textContent).toEqual("Неизвестная ошибка");


    let changeAndCheckError = async (currentErrorResponseCode: ErrorResponseCode) => {
      await harness.navigateByUrl(`/`);
      await harness.navigateByUrl(`/error?error=${currentErrorResponseCode}`, ErrorComponent);
      harness.detectChanges();
      h2 = harness.routeDebugElement!.query(By.css("h2")).nativeElement as HTMLParagraphElement;
      expect(h2.textContent).toEqual(ErrorOnPageModel.getErrorResponseCodeRus(currentErrorResponseCode));
    }

    await changeAndCheckError(ErrorResponseCode.AccessDenied);
    await changeAndCheckError(ErrorResponseCode.InsufficientScope);
    await changeAndCheckError(ErrorResponseCode.InvalidClient);
    await changeAndCheckError(ErrorResponseCode.InvalidGrant);
    await changeAndCheckError(ErrorResponseCode.InvalidRedirectUri);
    await changeAndCheckError(ErrorResponseCode.InvalidRequest);
    await changeAndCheckError(ErrorResponseCode.InvalidScope);
    await changeAndCheckError(ErrorResponseCode.InvalidToken);
    await changeAndCheckError(ErrorResponseCode.ServerError);
    await changeAndCheckError(ErrorResponseCode.TemporarilyUnavailable);
    await changeAndCheckError(ErrorResponseCode.UnauthorizedClient);
    await changeAndCheckError(ErrorResponseCode.UnsupportedGrantType);
    await changeAndCheckError(ErrorResponseCode.UnsupportedResponseType);
    await changeAndCheckError(ErrorResponseCode.UnsupportedTokenType);

  });


  it('goToAuth',  fakeAsync(async () => {

    // given (instead of when)
    
    const window = {
      "location": {
        "href": {}
      }
    }
    
    const comp = await harness.navigateByUrl(`/error?error=${error}&error_description=${error_description}&reauthentication_location=${reauthentication_location}`, ErrorComponent);
    harness.detectChanges();

    windowServiceSpy.get.and.returnValue(window);

    // when
    expect(comp).toBeTruthy();

    harness.detectChanges();
    let button = harness.routeDebugElement!.query(By.css("button[mat-raised-button]")).nativeElement as HTMLButtonElement;
    button.click();
    harness.detectChanges();

    expect(window.location.href).toEqual(reauthentication_location);
  }));

});