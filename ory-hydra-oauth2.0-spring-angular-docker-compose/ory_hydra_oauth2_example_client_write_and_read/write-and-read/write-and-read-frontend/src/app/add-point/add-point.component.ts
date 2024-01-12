import { Component, HostListener, OnDestroy } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { Subject, first, takeUntil } from 'rxjs';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { CommonModule } from '@angular/common';
import { AppService } from '../app.service';
import { HttpErrorResponse } from '@angular/common/http';
import { MatSnackBar, MatSnackBarConfig } from '@angular/material/snack-bar';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';

@Component({
  selector: 'app-add-point',
  standalone: true,
  imports: [
    CommonModule,
    MatButtonModule,
    MatTooltipModule,
    MatProgressSpinnerModule
  ],
  templateUrl: './add-point.component.html',
  styleUrl: './add-point.component.scss'
})
export class AddPointComponent implements OnDestroy {
  // to clear the rxjs memory
  // для очистки памяти rxjs
  private readonly onDestroy = new Subject<void>();

  // waiting for a response from the server
  // ожидание ответа от сервера
  getResponseFromServerFlag: boolean = false;

  readonly actionCloseButtonName = 'CLOSE';
  readonly confOptionsSnackbar: MatSnackBarConfig<any> = {
    duration: 5000
  };

  @HostListener('window:keydown.enter', ['$event']) onKeydownEnterHandler(event: KeyboardEvent) { 
    this.addValue();
  }

  constructor(
    private appService: AppService, 
    private matSnackBar: MatSnackBar,
    private generationCookieCsrfService: GenerationCookieCsrfService){}

  addValue(){
    
    if (!this.getResponseFromServerFlag) {

      this.getResponseFromServerFlag = true;

      this.generationCookieCsrfService.generateCookieCsrf();

      this.appService.change()
        .pipe(
          first(),
          takeUntil(this.onDestroy)
        )
        .subscribe({
          next: (el) => {

            this.matSnackBar.open("Success", this.actionCloseButtonName, this.confOptionsSnackbar);
            
            // ответ получили
            this.getResponseFromServerFlag = false;
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
