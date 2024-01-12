import { Injectable } from '@angular/core';
import { CookieService } from './cookie.service';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class SaveFutureRedirectService {

  readonly urlCookieName = "CURRENT_URI";

  constructor(
    private cookieService: CookieService,
    private router: Router
  ) { }

  saveIfNotExist(){

    if(!this.cookieService.getCookie(this.urlCookieName)){
      this.cookieService.setCookie(this.urlCookieName, this.router.url, {
        path: '/',
        secure: true,
        samesite: 'lax'
      });
    }
  }

  redirectAndClearIfExist(){
    let url:string | undefined = this.cookieService.getCookie(this.urlCookieName);

    if(url){

      this.cookieService.deleteCookie(this.urlCookieName);

      this.router.navigateByUrl(url);
    }
  }
}
