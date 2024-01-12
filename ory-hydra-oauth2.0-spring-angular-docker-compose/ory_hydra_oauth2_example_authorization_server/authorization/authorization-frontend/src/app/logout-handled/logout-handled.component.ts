import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Params } from '@angular/router';
import { Observable, Subject, first, map, takeUntil } from 'rxjs';
import { WindowService } from '../window.service';
import { CookieService } from '../cookie.service';

@Component({
  selector: 'app-logout-handled',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './logout-handled.component.html',
  styleUrl: './logout-handled.component.scss'
})
export class LogoutHandledComponent implements OnDestroy {

  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  isConfirmed$:  Observable<boolean>;

  constructor(private route: ActivatedRoute, private windowService: WindowService, private cookieService: CookieService) {

    this.isConfirmed$ = this.route.params
      .pipe(
        first(),
        map((params: Params) =>
          params["status"] === 'success'
        ),
        map((flag: boolean) => {
          if(this.cookieService.getCookie("logout") === "logout"){
            this.cookieService.deleteCookie("logout");
            this.windowService.get().history.go(-2);
          } else {
            this.windowService.get().history.go(-1);
          }
          return flag;
        }),
        takeUntil(this.onDestroy)
      );

  }

  ngOnDestroy(): void {
    this.onDestroy.next();
    this.onDestroy.complete();
  }
}
