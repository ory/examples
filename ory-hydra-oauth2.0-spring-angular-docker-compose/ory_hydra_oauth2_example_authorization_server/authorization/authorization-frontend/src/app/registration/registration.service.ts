import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError, throwError } from 'rxjs';
import { ErrorService } from '../error.service';
import { environment } from '../../environments/environment';

@Injectable()
export class RegistrationService {

  constructor(private http: HttpClient, private errorService: ErrorService) { }

  registration(
    login: string,
    password: string,
    orgName: string
  ): Observable<number>{
    return this.http.post<number>(`${environment.apiUrl}/registration`, {
      login: login,
      password: password,
      orgName: orgName
    })
    .pipe(
      catchError(this.errorHandler.bind(this))
    );
  }

  private errorHandler(error: HttpErrorResponse) {
    this.errorService.handle(error.error)
    return throwError(() => error)
  }
}

