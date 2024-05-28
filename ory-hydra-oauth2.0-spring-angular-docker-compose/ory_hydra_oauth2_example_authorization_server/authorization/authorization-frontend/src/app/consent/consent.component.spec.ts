import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';

import { ConsentComponent } from './consent.component';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { ConsentService } from './consent.service';
import { WindowService } from '../window.service';
import { DebugElement } from '@angular/core';
import { MatCheckboxHarness } from '@angular/material/checkbox/testing';
import { TestbedHarnessEnvironment } from '@angular/cdk/testing/testbed';
import { HarnessLoader } from '@angular/cdk/testing';
import { By } from '@angular/platform-browser';
import { of, throwError } from 'rxjs';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { HttpErrorResponse } from '@angular/common/http';

describe('ConsentComponent', () => {
  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let consentServiceSpy: jasmine.SpyObj<ConsentService>;
  let windowServiceSpy: jasmine.SpyObj<WindowService>;

  let component: ConsentComponent;
  let fixture: ComponentFixture<ConsentComponent>;

  let hostDe: DebugElement;

  let checkbox: MatCheckboxHarness;
  let allowButton: HTMLButtonElement;
  let denyButton: HTMLButtonElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ConsentComponent],
      providers: [
        {
          provide: GenerationCookieCsrfService,
          useValue: jasmine.createSpyObj('GenerationCookieCsrfService', ['generateCookieCsrf'])
        },
        {
          provide: ConsentService,
          useValue: jasmine.createSpyObj('ConsentService', ['clientName', 'scopes', 'subject', 'consentSuccess', 'consentCancel'])
        },
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        }
      ]
    })
      .compileComponents()
      .then(async () => {
        generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
        consentServiceSpy = TestBed.inject(ConsentService) as jasmine.SpyObj<ConsentService>;
        windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;

        const clientName: string = 'Some client';
        const subject: string = 'Some Subject';
        const scopes: string[] = ['read', "write"];

        consentServiceSpy.clientName.and.returnValue(of(clientName));
        consentServiceSpy.subject.and.returnValue(of(subject));
        consentServiceSpy.scopes.and.returnValue(of(scopes));

        fixture = TestBed.createComponent(ConsentComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();

        let loader: HarnessLoader = TestbedHarnessEnvironment.loader(fixture)

        checkbox = await loader.getHarness(MatCheckboxHarness.with({ name: 'isRemember' }));

        hostDe = fixture.debugElement;

        allowButton = hostDe.query(By.css("#allowButton")).nativeElement;
        denyButton = hostDe.query(By.css("#denyButton")).nativeElement;

      });

  });


  it('consent should be succeed (GUI)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    consentServiceSpy.consentSuccess.and.returnValue(of(responseWithRedirectModel));
        
    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    // when

    checkbox.toggle();
    tick();

    fixture.detectChanges();
    expect(component.isRemember.value).withContext("component.isRemember === true").toEqual(true);

    allowButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(consentServiceSpy.consentSuccess.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(consentServiceSpy.consentSuccess.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${true} ]`)
      .toEqual([true]);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);

  }));

  it('consent should be succeed (GUI) (enter)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    consentServiceSpy.consentSuccess.and.returnValue(of(responseWithRedirectModel));
        
    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    // when

    // enter
    window.dispatchEvent(new KeyboardEvent('keydown', {
      key: 'enter'
    }));
    fixture.detectChanges();

    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(consentServiceSpy.consentSuccess.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(consentServiceSpy.consentSuccess.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${false} ]`)
      .toEqual([false]);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);
  }));


  it('deny (GUI)', fakeAsync(() => {
    // given (instead of when)
    
    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    consentServiceSpy.consentCancel.and.returnValue(of(responseWithRedirectModel));
        
    const windowObj = {
      "location": {
        "href": {}
      }
    }
    windowServiceSpy.get.and.returnValue(windowObj);

    // when

    denyButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(consentServiceSpy.consentCancel.calls.count())
      .withContext("consentServiceSpy.consentCancel.calls.count() !== 1")
      .toBe(1);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);
  }));

  it('deny (GUI) (esc)', fakeAsync(() => {
    // given (instead of when)

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };
    consentServiceSpy.consentCancel.and.returnValue(of(responseWithRedirectModel));
        
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

    expect(consentServiceSpy.consentCancel.calls.count())
      .withContext("consentServiceSpy.consentCancel.calls.count() !== 1")
      .toBe(1);

    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);
  }));

  it('consentSuccess (GUI) (esc) (fail)', fakeAsync(() => {
    // given (instead of when)

    consentServiceSpy.consentSuccess.and.returnValue(throwError(() => new HttpErrorResponse({status: 404})));
    // when

    checkbox.toggle();
    tick();

    fixture.detectChanges();
    expect(component.isRemember.value).withContext("component.isRemember === true").toEqual(true);

    allowButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(consentServiceSpy.consentSuccess.calls.count())
      .withContext("consentServiceSpy.consentSuccess.calls.count() !== 1")
      .toBe(1);
    expect(consentServiceSpy.consentSuccess.calls.first().args)
      .withContext(`consentServiceSpy.consentSuccess.calls.first().args != [${true} ]`)
      .toEqual([true]);


  }));

  it('deny (GUI) (fail)', fakeAsync(() => {
    // given (instead of when)
    
    consentServiceSpy.consentCancel.and.returnValue(throwError(() => new HttpErrorResponse({status: 404})));
    // when

    denyButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(consentServiceSpy.consentCancel.calls.count())
      .withContext("consentServiceSpy.consentCancel.calls.count() !== 1")
      .toBe(1);

  }));


});
