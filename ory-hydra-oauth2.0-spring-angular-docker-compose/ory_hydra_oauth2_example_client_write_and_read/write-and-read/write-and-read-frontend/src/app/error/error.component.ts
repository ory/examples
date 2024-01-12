import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Observable, Subject, first, map, takeUntil } from 'rxjs';
import { ActivatedRoute } from '@angular/router';

import {MatButtonModule} from '@angular/material/button';
import { WindowService } from '../window.service';
import { ErrorOnPageModel } from '../models/error-on-page.model';

@Component({
  selector: 'app-error',
  standalone: true,
  imports: [CommonModule, MatButtonModule],
  templateUrl: './error.component.html',
  styleUrl: './error.component.scss'
})
export class ErrorComponent implements OnDestroy {
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  errorOnPageModel$: Observable<ErrorOnPageModel>;

  constructor(
    private windowService: WindowService,
    private route: ActivatedRoute
  ) {

    this.errorOnPageModel$ = this.route.queryParamMap
      .pipe(
        first(),
        map(
          (paramMap) => {
            let error: string | null = paramMap.get("error");
            let errorDescription: string | null = paramMap.get("error_description");
            let reauthenticationLocation: string | null = paramMap.get("reauthentication_location");

            if (error) {
              error = ErrorOnPageModel.getErrorResponseCodeRus(error);
            } else {
              error = "Неизвестная ошибка"
            }

            if (!errorDescription) {
              errorDescription = "Неизвестное описание"
            }

            if (!reauthenticationLocation) {
              reauthenticationLocation = '/';
            }

            return new ErrorOnPageModel(error, errorDescription, reauthenticationLocation);
          }
        ),
        takeUntil(this.onDestroy)
      )
  }

  goToAuth(url: string) {
    this.windowService.get().location.href = url;
  }

  ngOnDestroy(): void {
    this.onDestroy.next();
    this.onDestroy.complete();
  }


}