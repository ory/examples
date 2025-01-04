import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { DebugElement, Renderer2 } from '@angular/core';

import { RegistrationComponent } from './registration.component';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { RegistrationService } from './registration.service';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { of, throwError } from 'rxjs';
import { By } from '@angular/platform-browser';
import { HttpErrorResponse } from '@angular/common/http';

describe('RegistrationComponent', () => {
  let renderer2Spy: jasmine.SpyObj<Renderer2>;
  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let registrationServiceSpy: jasmine.SpyObj<RegistrationService>;
  
  let component: RegistrationComponent;
  let fixture: ComponentFixture<RegistrationComponent>;

  let hostDe: DebugElement;

  let loginInput: HTMLInputElement;
  let passwordInput: HTMLInputElement;
  let repeatPasswordInput: HTMLInputElement;
  let orgNameInput: HTMLInputElement;
  let submitButton: HTMLButtonElement;

  let hideOrShowPasswordButton1: HTMLButtonElement;
  let hideOrShowPasswordButton2: HTMLButtonElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        MatFormFieldModule,
        MatInputModule,
        MatTooltipModule,
        ReactiveFormsModule,
        MatButtonModule,
        MatProgressSpinnerModule,
        BrowserAnimationsModule
      ],
      declarations: [RegistrationComponent],
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
          provide: RegistrationService, 
          useValue: jasmine.createSpyObj('RegistrationService', ['registration'])
        }
      ]
    }).compileComponents();
  });


  beforeEach(() => {
    renderer2Spy = TestBed.inject(Renderer2) as jasmine.SpyObj<Renderer2>;
    generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
    registrationServiceSpy = TestBed.inject(RegistrationService) as jasmine.SpyObj<RegistrationService>;

    fixture = TestBed.createComponent(RegistrationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
    
    hostDe = fixture.debugElement;

    loginInput = hostDe.query(By.css("#login")).nativeElement;
    passwordInput = hostDe.query(By.css("#password")).nativeElement;
    repeatPasswordInput = hostDe.query(By.css("#repeatPassword")).nativeElement;
    orgNameInput = hostDe.query(By.css("#orgName")).nativeElement;
    submitButton = hostDe.query(By.css("#submitButton")).nativeElement;

    hideOrShowPasswordButton1 = hostDe.query(By.css("#hideOrShowPasswordButton1")).nativeElement;
    hideOrShowPasswordButton2 = hostDe.query(By.css("#hideOrShowPasswordButton2")).nativeElement;
  });

  it('should create', () => {
    expect(component).toBeDefined();
  });

  it('registration should be succeed', fakeAsync(() => {
    // given (instead of when)
    
    const expectedLogin ="someLogin";
    const expectedPassword = "4Jof0#@V4cTaFev0";
    const expectedOrgName = "someOrg";
  
    registrationServiceSpy.registration.and.returnValue(of(1));

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

    repeatPasswordInput.value = expectedPassword;
    repeatPasswordInput.dispatchEvent(new Event('input'));

    orgNameInput.value = expectedOrgName;
    orgNameInput.dispatchEvent(new Event('input'));

    fixture.detectChanges();

    // check hide/show password
    hideOrShowPasswordButton1.click();
    tick();
    expect(component.passwordShowFlag).withContext("passwordShowFlag1 === false").toEqual(true);

    hideOrShowPasswordButton1.click();
    tick();
    expect(component.passwordShowFlag).withContext("passwordShowFlag1 === true").toEqual(false);

    hideOrShowPasswordButton2.click();
    tick();
    expect(component.passwordShowFlag2).withContext("passwordShowFlag2 === false").toEqual(true);

    hideOrShowPasswordButton2.click();
    tick();
    expect(component.passwordShowFlag2).withContext("passwordShowFlag2 === true").toEqual(false);

    // form valid?
    expect(submitButton.disabled).withContext("submitButton.disabled === true").toEqual(false);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === true").toEqual(false);

    submitButton.click();
    tick(10000);
    
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(registrationServiceSpy.registration.calls.count())
      .withContext("registrationServiceSpy.registration.calls.count() !== 1")
      .toBe(1);
    expect(registrationServiceSpy.registration.calls.first().args)
      .withContext(`registrationServiceSpy.registration.calls.first().args != [${expectedLogin} ${expectedPassword} ${expectedOrgName}]`)
      .toEqual([expectedLogin, expectedPassword, expectedOrgName]);

  }));

  it('registration should be fail (enter)', fakeAsync(() => {
    // given (instead of when)
    
    const expectedLogin ="someLogin";
    const expectedPassword = "4Jof0#@V4cTaFev0";
    const expectedOrgName = "someOrg";
  
    registrationServiceSpy.registration.and.returnValue(throwError(() => new HttpErrorResponse({status: 404})));

    // when

    loginInput.value = expectedLogin;
    loginInput.dispatchEvent(new Event('input'));

    passwordInput.value = expectedPassword;
    passwordInput.dispatchEvent(new Event('input'));

    repeatPasswordInput.value = expectedPassword;
    repeatPasswordInput.dispatchEvent(new Event('input'));

    orgNameInput.value = expectedOrgName;
    orgNameInput.dispatchEvent(new Event('input'));

    fixture.detectChanges();

    // form valid?
    expect(submitButton.disabled).withContext("submitButton.disabled === true").toEqual(false);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === true").toEqual(false);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'enter'
    }));

    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(registrationServiceSpy.registration.calls.count())
      .withContext("registrationServiceSpy.registration.calls.count() !== 1")
      .toBe(1);
    expect(registrationServiceSpy.registration.calls.first().args)
      .withContext(`registrationServiceSpy.registration.calls.first().args != [${expectedLogin} ${expectedPassword} ${expectedOrgName}]`)
      .toEqual([expectedLogin, expectedPassword, expectedOrgName]);

  }));

  it('registration should be succeed (enter)', () => {
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
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(passwordInput);

    // repeatPassword focus
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'r',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(repeatPasswordInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'R',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(repeatPasswordInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'К',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(repeatPasswordInput);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'к',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(repeatPasswordInput);

    // orgName focus

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'o',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(orgNameInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'O',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(orgNameInput);
    
    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'щ',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(orgNameInput);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'Щ',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(orgNameInput);

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'b',
      ctrlKey: true
    }));
    fixture.detectChanges();
    focusElement = hostDe.query(By.css(":focus")).nativeElement;
    expect(focusElement).toBe(orgNameInput);


    // then (instead of verify)

  });


  it('login invalid', () => {
    // given (instead of when)
    
    const expectedLogin ="som";

    // when
    
    loginInput.value = expectedLogin;
    loginInput.dispatchEvent(new Event('input'));
    window.dispatchEvent(new KeyboardEvent('keypress',{
      key: 'tab'
    }));

    fixture.detectChanges();

    expect(component.login.invalid && (component.login.dirty || component.login.touched) &&  component.login.errors?.['minlength']).toBeTruthy();
    expect(submitButton.disabled).withContext("submitButton.disabled === false").toEqual(true);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === false").toEqual(true);

    // then (instead of verify)


  });

  it('password invalid', () => {
    // given (instead of when)
    
    const expectedPassword = "zcvs";

    // when
    
    passwordInput.value = expectedPassword;
    passwordInput.dispatchEvent(new Event('input'));
    window.dispatchEvent(new KeyboardEvent('keypress',{
      key: 'tab'
    }));

    fixture.detectChanges();

    expect(component.password.invalid && (component.password.dirty || component.password.touched) &&  component.password.errors?.['pattern']).toBeTruthy();
    expect(submitButton.disabled).withContext("submitButton.disabled === false").toEqual(true);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === false").toEqual(true);

    // then (instead of verify)


  });

  it('orgName invalid', () => {
    // given (instead of when)
    
    const expectedOrgName = "xzv";

    // when
    
    orgNameInput.value = expectedOrgName;
    orgNameInput.dispatchEvent(new Event('input'));
    window.dispatchEvent(new KeyboardEvent('keypress',{
      key: 'tab'
    }));

    fixture.detectChanges();

    expect(component.orgName.invalid && (component.orgName.dirty || component.orgName.touched) &&  component.orgName.errors?.['minlength']).toBeTruthy();
    expect(submitButton.disabled).withContext("submitButton.disabled === false").toEqual(true);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === false").toEqual(true);

    // then (instead of verify)


  });

  it('repeatPassword invalid', () => {
    // given (instead of when)
    
    const expectedPassword = "zcvs";
    const expectedRepeatPassword = "zcvs4";

    // when
    
    passwordInput.value = expectedPassword;
    passwordInput.dispatchEvent(new Event('input'));
    repeatPasswordInput.value = expectedRepeatPassword;
    repeatPasswordInput.dispatchEvent(new Event('input'));

    window.dispatchEvent(new KeyboardEvent('keypress',{
      key: 'tab'
    }));

    fixture.detectChanges();

    const erElement: HTMLElement = hostDe.query(By.css(".er")).nativeElement;
    expect(erElement.textContent).toContain("Password mismatch");
    
    expect(submitButton.disabled).withContext("submitButton.disabled === false").toEqual(true);
    expect(component.registrationFormGroup.invalid).withContext("submitButton.disabled === false").toEqual(true);

    // then (instead of verify)


  });

});