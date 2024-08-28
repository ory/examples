import { Component, HostListener, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { Subject, first, takeUntil } from 'rxjs';
import { LogoutService } from '../logout.service';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { WindowService } from '../window.service';
import { HttpErrorResponse } from '@angular/common/http';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { CookieService } from '../cookie.service';

@Component({
  selector: 'app-logout-request',
  standalone: true,
  imports: [
    CommonModule,
    MatProgressSpinnerModule,
    MatButtonModule,
    MatTooltipModule
  ],
  templateUrl: './logout-request.component.html',
  styleUrl: './logout-request.component.scss'
})
export class LogoutRequestComponent implements OnDestroy {

  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  // waiting for a response from the server
  // ожидание ответа от сервера
  getResponseFromServerFlag: boolean = false;

  @HostListener('window:keydown.enter', ['$event']) onKeydownEnterHandler(event: KeyboardEvent) {
    this.isConfirmedOrNot(true);
  }

  @HostListener('window:keydown.esc', ['$event']) onKeydownEnterHandler2(event: KeyboardEvent) {
    this.isConfirmedOrNot(false);
  }

  constructor(private logoutService: LogoutService,
    private generationCookieCsrfService: GenerationCookieCsrfService,
    private windowService: WindowService,
    private cookieService: CookieService) { }

  isConfirmedOrNot(isConfirmed: boolean) {

    if (!this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.cookieService.setCookie("logout", "logout", {
        path: '/',
        'max-age': 120,
        secure: true,
        samesite: 'lax'
      });

      this.logoutService.logoutSendResponse(isConfirmed)
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
