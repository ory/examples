import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';

import { LoginComponent } from './login.component';
import { DebugElement, Renderer2 } from '@angular/core';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { LoginService } from './login.service';
import { By } from '@angular/platform-browser';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { of, throwError } from 'rxjs';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { WindowService } from '../window.service';

import {TestbedHarnessEnvironment} from '@angular/cdk/testing/testbed';
import { HarnessLoader } from '@angular/cdk/testing';
import {MatCheckboxHarness} from '@angular/material/checkbox/testing';
import { HttpErrorResponse } from '@angular/common/http';

describe('LoginComponent', () => {
  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let loginServiceSpy: jasmine.SpyObj<LoginService>;
  let windowServiceSpy: jasmine.SpyObj<WindowService>;
  
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;

  let hostDe: DebugElement;

  let loginInput: HTMLInputElement;
  let passwordInput: HTMLInputElement;
  let checkbox:MatCheckboxHarness;
  let submitButton: HTMLButtonElement;

  let hideOrShowPasswordButton: HTMLButtonElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LoginComponent, NoopAnimationsModule],
      providers: [
        {
          provide: Renderer2, 
          useValue: jasmine.createSpyObj('Renderer2', ['selectRootElement'])
        },
        {
          provide: GenerationCookieCsrfService, 
          useValue: jasmine.createSpyObj('GenerationCookieCsrfService', ['generateCookieCsrf'])
        },
        {
          provide: LoginService, 
          useValue: jasmine.createSpyObj('LoginService', ['login'])
        },
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        }
      ]
    })
    .compileComponents()
    .then(async () => {
      generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
      loginServiceSpy = TestBed.inject(LoginService) as jasmine.SpyObj<LoginService>;
      windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;
  
      fixture = TestBed.createComponent(LoginComponent);
      component = fixture.componentInstance;
      fixture.detectChanges();
      
      let loader: HarnessLoader =TestbedHarnessEnvironment.loader(fixture)

      checkbox = await loader.getHarness(MatCheckboxHarness.with({ name: 'isRemember'}));

      hostDe = fixture.debugElement;
  
      loginInput = hostDe.query(By.css("#login")).nativeElement;
      passwordInput = hostDe.query(By.css("#password")).nativeElement;
      submitButton = hostDe.query(By.css("#submitButton")).nativeElement;
  
      hideOrShowPasswordButton = hostDe.query(By.css("button[matTooltip='Show Password']")).nativeElement;
      
    });
    
  });



  it('should create', () => {
    expect(component).toBeTruthy();
  });

  
  it('login should be succeed (GUI)', fakeAsync(() => {
    // given (instead of when)
    
    const expectedLogin ="someLogin";
    const expectedPassword = "4Jof0#@V4cTaFev0";

    const responseWithRedirectModel: ResponseWithRedirectModel = {
      redirect_to: "/some_url"
    };

    loginServiceSpy.login.and.returnValue(of(responseWithRedirectModel));

    const window = {
      "location": {
        "href": {}
      }
    }

    windowServiceSpy.get.and.returnValue(window);

    // check autofocus
    component.ngAfterViewInit();
    tick(2);
    fixture.detectChanges();
    const focusElement: HTMLElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(loginInput);

    // when

    loginInput.value = expectedLogin;
    loginInput.dispatchEvent(new Event('input'));

    passwordInput.value = expectedPassword;
    passwordInput.dispatchEvent(new Event('input'));

    checkbox.toggle();
    tick();    

    fixture.detectChanges();
    expect(component.isRemember.value).withContext("component.isRemember === true").toEqual(true);


    // check hide/show password
    hideOrShowPasswordButton.click();
    tick();
    expect(component.passwordShowFlag).withContext("passwordShowFlag === false").toEqual(true);

    hideOrShowPasswordButton.click();
    tick();
    expect(component.passwordShowFlag).withContext("passwordShowFlag === true").toEqual(false);

    // form valid?
    expect(submitButton.disabled).withContext("submitButton.disabled === true").toEqual(false);
    expect(component.loginFormGroup.invalid).withContext("component.loginFormGroup.invalid === true").toEqual(false);

    submitButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(loginServiceSpy.login.calls.count())
      .withContext("loginServiceSpy.login.calls.count() !== 1")
      .toBe(1);
    expect(loginServiceSpy.login.calls.first().args)
      .withContext(`loginServiceSpy.login.calls.first().args != [${expectedLogin} ${expectedPassword} ${component.isRemember.value} ]`)
      .toEqual([expectedLogin, expectedPassword, component.isRemember.value]);
   
    expect(windowServiceSpy.get.calls.count())
      .withContext("windowServiceSpy.get.calls.count() !== 1")
      .toBe(1);
  }));


  it('login should be fail (GUI)', fakeAsync(() => {
    // given (instead of when)
    
    const expectedLogin ="someLogin";
    const expectedPassword = "4Jof0#@V4cTaFev0";

    loginServiceSpy.login.and.returnValue(throwError(() => new HttpErrorResponse({status: 404})));

    const window = {
      "location": {
        "href": {}
      }
    }

    windowServiceSpy.get.and.returnValue(window);

    // when

    loginInput.value = expectedLogin;
    loginInput.dispatchEvent(new Event('input'));

    passwordInput.value = expectedPassword;
    passwordInput.dispatchEvent(new Event('input'));

    checkbox.toggle();
    tick();    

    fixture.detectChanges();
    
    // form valid?

    submitButton.click();
    tick();
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(loginServiceSpy.login.calls.count())
      .withContext("loginServiceSpy.login.calls.count() !== 1")
      .toBe(1);
    expect(loginServiceSpy.login.calls.first().args)
      .withContext(`loginServiceSpy.login.calls.first().args != [${expectedLogin} ${expectedPassword} ${component.isRemember.value} ]`)
      .toEqual([expectedLogin, expectedPassword, component.isRemember.value]);

  }));

  it('test hot key', () => {
    // given (instead of when)
    
    // when
    
    // login focus

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'l',
      ctrlKey: true
    }));
    fixture.detectChanges();
    let focusElement: HTMLElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(loginInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'L',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(loginInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'д',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(loginInput);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'Д',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(loginInput);

    // password focus

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'p',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'P',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'З',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'з',
      ctrlKey: true
    }));
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'ж',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);

    // enter
    window.dispatchEvent(new KeyboardEvent('keydown', {
      key: 'enter'
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);

    // then (instead of verify)

  });


});
