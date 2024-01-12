import { Component, HostListener, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';

import { MatDividerModule } from '@angular/material/divider';
import { MatListModule } from '@angular/material/list';
import { Observable, Subject, first, takeUntil } from 'rxjs';
import { ConsentService } from './consent.service';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { HttpErrorResponse } from '@angular/common/http';
import { WindowService } from '../window.service';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-consent',
  standalone: true,
  imports: [
    CommonModule,
    MatButtonModule,
    MatCheckboxModule,
    MatDividerModule,
    MatListModule,
    ReactiveFormsModule,
    MatProgressSpinnerModule,
    MatTooltipModule
  ],
  templateUrl: './consent.component.html',
  styleUrl: './consent.component.scss'
})
export class ConsentComponent implements OnDestroy {
  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  // meta info
  requestedScopes$: Observable<string[]>;
  subject$: Observable<string>;
  clientName$: Observable<string>;

  readonly isRemember = new FormControl(false);

  // waiting for a response from the server
  // ожидание ответа от сервера
  getResponseFromServerFlag: boolean = false;

  constructor(private consentService: ConsentService,
    private generationCookieCsrfService: GenerationCookieCsrfService,
    private windowService: WindowService) {

    this.requestedScopes$ = this.consentService.scopes()
      .pipe(
        first(),
        takeUntil(this.onDestroy)
      );

    this.subject$ = this.consentService.subject()
      .pipe(
        first(),
        takeUntil(this.onDestroy)
      );

    this.clientName$ = this.consentService.clientName()
      .pipe(
        first(),
        takeUntil(this.onDestroy)
      );
  }

  @HostListener('window:keydown.enter', ['$event']) onKeydownEnterHandler(event: KeyboardEvent) {
    this.allowAccess(!!this.isRemember.value);
    return;
  }

  @HostListener('window:keydown.esc', ['$event']) onKeydownEscHandler(event: KeyboardEvent) {
    this.denyAccess();
    return;
  }

  allowAccess(isRemember: boolean) {
    if (!this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.consentService.consentSuccess(isRemember)
        .pipe(
          first(),
          takeUntil(this.onDestroy)
        )
        .subscribe({
          next: (responseLogin) => {

            this.windowService.get().location.href = responseLogin.redirect_to;

          },
          error: (error: HttpErrorResponse) => {

            // received response
            // ответ получили
            this.getResponseFromServerFlag = false;
          }
        });
    }
  }

  denyAccess() {


    if (!this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.consentService.consentCancel()
        .pipe(
          first(),
          takeUntil(this.onDestroy)
        )
        .subscribe({
          next: (responseLogin) => {

            this.windowService.get().location.href = responseLogin.redirect_to;

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
