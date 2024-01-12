import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError, throwError } from 'rxjs';
import { Point } from './models/point.model';
import { environment } from '../environments/environment';
import { ErrorService } from './error.service';

@Injectable({
  providedIn: 'root'
})
export class AppService {

  constructor(private http: HttpClient, private errorService: ErrorService) {}

  getData(): Observable<Point[]> {
    return this.http.get<Point[]>(`${environment.apiUrl}/data`)
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  private errorHandler(error: HttpErrorResponse) {
    this.errorService.handle(error.error)
    return throwError(() => error)
  }
}
