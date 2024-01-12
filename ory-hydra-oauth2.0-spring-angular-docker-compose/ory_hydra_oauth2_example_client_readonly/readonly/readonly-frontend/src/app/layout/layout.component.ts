import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Subject, takeUntil } from 'rxjs';
import { environment } from '../../environments/environment';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { AuthService } from '../auth.service';
import { SaveFutureRedirectService } from '../save-future-redirect.service';
import { RouterOutlet } from '@angular/router';

import {MatToolbarModule} from '@angular/material/toolbar';
import {MatButtonModule} from '@angular/material/button';
import { WindowService } from '../window.service';


@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, MatToolbarModule, MatButtonModule],
  templateUrl: './layout.component.html',
  styleUrl: './layout.component.scss'
})
export class LayoutComponent implements OnDestroy {
  
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  constructor(private generationCookieCsrfService: GenerationCookieCsrfService,
              private authService: AuthService,
              private saveFutureRedirectService: SaveFutureRedirectService,
              private windowService: WindowService
              ) {

  }

  logout() {

    this.generationCookieCsrfService.generateCookieCsrf();

    let logoutHandler: (() => void) = () => {

      //запоминаем в cookie текущий url
      this.saveFutureRedirectService.saveIfNotExist();

      this.windowService.get().location.href = `${environment.authServerBaseUrl}/oauth2/sessions/logout`;
    };

    this.authService.logout()
      .pipe(
        takeUntil(this.onDestroy)
      )
      .subscribe({
        next: logoutHandler,
        error: logoutHandler,
        complete: logoutHandler
      });


  }

  ngOnDestroy(): void {
    this.onDestroy.next();
    this.onDestroy.complete();
  }
}
