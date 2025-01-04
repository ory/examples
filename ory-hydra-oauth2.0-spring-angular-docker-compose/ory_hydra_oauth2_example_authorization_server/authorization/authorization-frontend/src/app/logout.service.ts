import { Injectable } from '@angular/core';
import { ResponseWithRedirectModel } from './models/response-with-redirect.model';
import { Observable, catchError, throwError } from 'rxjs';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { ErrorService } from './error.service';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LogoutService {

  constructor(private http: HttpClient, private errorService: ErrorService) { }

  logoutSendResponse(isConfirmed: boolean): Observable<ResponseWithRedirectModel> {
    return this.http.put<ResponseWithRedirectModel>(
      `${environment.apiUrl}/logout/`, {
      "isConfirmed": isConfirmed
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
