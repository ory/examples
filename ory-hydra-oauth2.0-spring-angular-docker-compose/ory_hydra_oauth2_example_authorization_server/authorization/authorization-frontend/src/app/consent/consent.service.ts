import { HttpClient, HttpErrorResponse, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ErrorService } from '../error.service';
import { Observable, catchError, map, throwError } from 'rxjs';
import { environment } from '../../environments/environment';
import { ResponseWithRedirectModel } from '../models/response-with-redirect.model';

@Injectable({
  providedIn: 'root'
})
export class ConsentService {
  constructor(private http: HttpClient, private errorService: ErrorService) { }

  clientName(): Observable<string> {
    const requestOptions: Object = {
      responseType: 'text'
    }
    
    return this.http.get<string>(
      `${environment.apiUrl}/consent/client-name`, requestOptions)
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  scopes(): Observable<string[]> {
    return this.http.get<string[]>(
      `${environment.apiUrl}/consent/scopes`)
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  subject(): Observable<string> {
    const requestOptions: Object = {
      responseType: 'text'
    }
    
    return this.http.get<string>(
      `${environment.apiUrl}/consent/subject`, requestOptions)
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  consentSuccess(isRemember: boolean = false): Observable<ResponseWithRedirectModel> {
    let params = new HttpParams();

    if(isRemember) {
      params = params.append('is-remember', isRemember);
    }

    return this.http.put<ResponseWithRedirectModel>(
      `${environment.apiUrl}/consent`, {}, { params: params })
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  consentCancel(): Observable<ResponseWithRedirectModel> {
    return this.http.delete<ResponseWithRedirectModel>(
      `${environment.apiUrl}/consent/cancel`, {})
      .pipe(
        catchError(this.errorHandler.bind(this))
      );
  }

  private errorHandler(error: HttpErrorResponse) {
    this.errorService.handle(error.error)
    return throwError(() => error)
  }
}
