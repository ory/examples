import { Injectable } from '@angular/core';
import { CookieService } from './cookie.service';

@Injectable({
  providedIn: 'root'
})
export class GenerationCookieCsrfService {


  readonly xsrfTokenCookieName = "XSRF-TOKEN"; 

  constructor(
    private cookieService: CookieService
  ) { }

  generateCookieCsrf(){

    //устанавливаем cookie от CSRF
    this.cookieService.setCookie(this.xsrfTokenCookieName, this.generateRandomString(20), {
      path: '/',
      'max-age': 120,
      secure: true,
      samesite: 'lax'
    });

  }

  private generateRandomString(length: number): string {

    let result: string = '';
    let characters: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let charactersLength: number = characters.length;

    for (let i: number = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }

    return result;
  }

}
