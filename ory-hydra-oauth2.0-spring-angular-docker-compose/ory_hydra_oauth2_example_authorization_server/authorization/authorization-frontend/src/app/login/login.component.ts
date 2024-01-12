import { Component, HostListener, OnDestroy, Renderer2 } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginService } from './login.service';
import { HttpClientModule, HttpErrorResponse } from '@angular/common/http';
import { Subject, first, takeUntil } from 'rxjs';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatTooltip, MatTooltipModule } from '@angular/material/tooltip';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';

import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

import { MatCheckboxModule } from '@angular/material/checkbox';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { WindowService } from '../window.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    CommonModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatProgressSpinnerModule,
    MatFormFieldModule,
    MatInputModule,
    MatTooltipModule,
    MatButtonModule,
    MatCheckboxModule
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent implements OnDestroy {
  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  readonly loginFormGroup = new FormGroup({
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
    isRemember: new FormControl(false, { nonNullable: true }),
  });

  get login() { return this.loginFormGroup.controls.login }
  get password() { return this.loginFormGroup.controls.password }
  get isRemember() { return this.loginFormGroup.controls.isRemember }

  // show or hide password
  // показывать или скрывать пароль
  passwordShowFlag: boolean = false;

  // waiting for a response from the server
  // ожидание ответа от сервера
  getResponseFromServerFlag: boolean = false;

  // show right side
  // показать правую часть
  isShowRightPart: boolean = true;

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
    }

    return;
  }

  constructor(
    private renderer: Renderer2,
    private generationCookieCsrfService: GenerationCookieCsrfService,
    private loginService: LoginService,
    private breakpointObserver: BreakpointObserver,
    private windowService: WindowService
  ) {

    this.breakpointObserver
      .observe(Breakpoints.Small)
      .subscribe(result => this.isShowRightPart = result.matches ? false : true)
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

  ngAfterViewInit() {
    setTimeout(() => {
      this.focusLogin();
    }, 1);
  }

  focusLogin() {
    this.renderer.selectRootElement("#login")?.focus();
  }

  submit() {

    if (this.loginFormGroup?.valid && !this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.loginService.login(
        this.login.value,
        this.password.value,
        this.isRemember.value
      )
        .pipe(
          first(),
          takeUntil(this.onDestroy)
        )
        .subscribe({
          next: (responseLogin) => {

            this.windowService.get().location.href = responseLogin.redirect_to;

            // received response
            // ответ получили
            this.getResponseFromServerFlag = false;
          },
          error: (error: HttpErrorResponse) => {

            // received response
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
