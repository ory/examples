import { CanActivateFn } from '@angular/router';
import { AuthService } from './auth.service';
import { inject } from '@angular/core';
import { SaveFutureRedirectService } from './save-future-redirect.service';
import { catchError, first, map, of, tap } from 'rxjs';
import { environment } from '../environments/environment';
import { WindowService } from './window.service';

export const authGuard: CanActivateFn = (route, state) => {

  const authService = inject(AuthService);
  const saveFutureRedirectService = inject(SaveFutureRedirectService);
  const windowService = inject(WindowService);

  return authService.checkAuthenticate()
    .pipe(
      first(),

      map(() => {

        //получаем сохраненый url, удаляем и перередиректуемся
        saveFutureRedirectService.redirectAndClearIfExist();

        return true;
      }),
      catchError(error => {

        if (error?.error?.redirect_to && error?.status === 401) {

          //запоминаем в cookie текущий url
          saveFutureRedirectService.saveIfNotExist();

          // перенаправляем напрямую приложение
          windowService.get().location.href = `${environment.apiUrl}${error.error.redirect_to}`;
        } else {
          windowService.get().location.href = '/error'
        }

        return of(false);
      })
    );
};