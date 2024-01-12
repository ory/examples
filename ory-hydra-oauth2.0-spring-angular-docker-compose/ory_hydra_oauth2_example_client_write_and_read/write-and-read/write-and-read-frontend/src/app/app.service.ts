import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError, throwError } from 'rxjs';
import { environment } from '../environments/environment';
import { ErrorService } from './error.service';

@Injectable({
  providedIn: 'root'
})
export class AppService {

  constructor(
    private http: HttpClient,
    private errorService: ErrorService
  ) { }

  change(): Observable<Object> {
    return this.http.put<Object>(`${environment.apiUrl}/change`, {})
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  private errorHandler(error: HttpErrorResponse) {
    this.errorService.handle(error.error)
    return throwError(() => error)
  }
}