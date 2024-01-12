import { Component, AfterViewInit, ElementRef, HostListener, OnDestroy, OnInit, QueryList, Renderer2, ViewChild, ViewChildren } from '@angular/core';
import { AbstractControl, FormControl, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { MatTooltip } from '@angular/material/tooltip';
import { Subject, first, takeUntil } from 'rxjs';
import { RegistrationService } from './registration.service';
import { HttpErrorResponse } from '@angular/common/http';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { MatSnackBar, MatSnackBarConfig } from '@angular/material/snack-bar';

@Component({
  selector: 'app-registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.scss']
})
export class RegistrationComponent implements AfterViewInit, OnDestroy {
  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  readonly registrationFormGroup = new FormGroup({
    login: new FormControl('', {
      nonNullable: true, validators: [
        Validators.required,
        Validators.minLength(4)
      ]
    }),
    password: new FormControl('', {
      nonNullable: true, validators: [
        Validators.required,
        Validators.pattern('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$')
      ]
    }),
    repeatPassword: new FormControl('', { nonNullable: true, validators: [
      Validators.required
    ]}),
    orgName: new FormControl('', {
      nonNullable: true, validators: [
        Validators.required,
        Validators.minLength(4)
      ]
    })
  }, { validators: repeatPasswordEqPasswordValidator });

  get login() { return this.registrationFormGroup.controls.login }
  get password() { return this.registrationFormGroup.controls.password }
  get repeatPassword() { return this.registrationFormGroup.controls.repeatPassword }
  get orgName() { return this.registrationFormGroup.controls.orgName }

  // show or hide password
  // показывать или скрывать пароль
  passwordShowFlag: boolean = false;
  passwordShowFlag2: boolean = false;

  // waiting for a response from the server
  // ожидание ответа от сервера
  getResponseFromServerFlag: boolean = false;
  // error from server
  // ошибка от сервера
  errorOnServer!: string | undefined;

  readonly actionCloseButtonName = 'CLOSE';
  readonly confOptionsSnackbar: MatSnackBarConfig<any> = {
    duration: 5000
  };

  @HostListener('window:keydown.enter', ['$event']) onKeydownEnterHandler(event: KeyboardEvent) { 
    this.submit();
  }

  @HostListener('window:keydown', ['$event']) onKeydownHandler(event: KeyboardEvent) {
    if (!event.ctrlKey) { return; }

    if (event.key === 'l' || event.key === 'L' || event.key === 'д' || event.key === 'Д') {
      this.focusLogin();
      return false;
    } else if (event.key === 'p' || event.key === 'P' || event.key === 'З' || event.key === 'з') {
      this.renderer.selectRootElement("#password")?.focus();
      return false;
    } else if (event.key === 'r' || event.key === 'R' || event.key === 'К' || event.key === 'к') {
      this.renderer.selectRootElement("#repeatPassword")?.focus();
      return false;
    } else if (event.key === 'o' || event.key === 'O' || event.key === 'щ' || event.key === 'Щ') {
      this.renderer.selectRootElement("#orgName")?.focus();
      return false;
    } 

    return;
  }

  constructor(
    private renderer: Renderer2,
    private generationCookieCsrfService: GenerationCookieCsrfService,
    private matSnackBar: MatSnackBar,
    private registationService: RegistrationService
  ) { }

  ngAfterViewInit() {
      setTimeout(() => {
        this.focusLogin();
      }, 1);
  }

  focusLogin() {
    this.renderer.selectRootElement("#login")?.focus();
  }


  passwordDisplay(tooltip: MatTooltip) {
    this.passwordShowFlag = !this.passwordShowFlag;

    if (this.passwordShowFlag) {
      tooltip.message = 'Hide Password';
    } else {
      tooltip.message = 'Show Password';
    }
    tooltip.show();
  }

  passwordDisplay2(tooltip: MatTooltip) {
    this.passwordShowFlag2 = !this.passwordShowFlag2;

    if (this.passwordShowFlag2) {
      tooltip.message = 'Hide Password';
    } else {
      tooltip.message = 'Show Password';
    }
    tooltip.show();
  }

  submit(){

    if (this.registrationFormGroup?.valid && !this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.registationService.registration(
        this.registrationFormGroup.controls.login.value,
        this.registrationFormGroup.controls.password.value,
        this.registrationFormGroup.controls.orgName.value
      )
      .pipe(
        first(),
        takeUntil(this.onDestroy)
      )
      .subscribe({
        next: (responseLogin) => {
          
          // ответ получили
          this.getResponseFromServerFlag = false;

          this.registrationFormGroup.reset();
          setTimeout(() => {
            this.focusLogin();
          }, 5);

          this.matSnackBar.open("Success", this.actionCloseButtonName, this.confOptionsSnackbar);
        },
        error: (error: HttpErrorResponse) => {

          // ответ получили
          this.getResponseFromServerFlag = false;
        }
      });

    }
  }

  ngOnDestroy(): void {
    this.onDestroy.next();
    this.onDestroy.complete();
  }
}

const repeatPasswordEqPasswordValidator: ValidatorFn = 
(control: AbstractControl): ValidationErrors | null => {
  
  const password = control.get('password');
  const repeatPassword = control.get('repeatPassword');

  return password && repeatPassword && password.value !== repeatPassword.value ? { notEq: true } : null;
};