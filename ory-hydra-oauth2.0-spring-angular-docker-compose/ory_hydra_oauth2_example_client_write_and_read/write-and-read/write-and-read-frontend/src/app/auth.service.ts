import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient) {}

  checkAuthenticate(): Observable<void> {
    return this.http.get<void>(`${environment.apiUrl}/logged-in`);
  }

  logout(): Observable<void>{
    return this.http.post<void>(`${environment.apiUrl}/logout`, {});
  }
}