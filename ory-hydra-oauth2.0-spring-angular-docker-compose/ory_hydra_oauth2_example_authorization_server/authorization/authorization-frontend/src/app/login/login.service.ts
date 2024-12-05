import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ErrorService } from '../error.service';
import { Observable, catchError, throwError } from 'rxjs';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient, private errorService: ErrorService) { }

  login(login: string, password: string, isRemember: boolean): Observable<ResponseWithRedirectModel> {
    return this.http.post<ResponseWithRedirectModel>(
      `${environment.apiUrl}/login`, 
      {
        "login": login,
        "password": password,
        "isRemember": isRemember
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
