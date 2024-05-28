import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class CookieService {

  // возвращает куки с указанным name,
  // или undefined, если ничего не найдено
  getCookie(name: string): string | undefined {

    let matches = document.cookie.match(new RegExp(
      "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
  }

  setCookie(name: string, value: string, options: any = {} ) {

    options = {
      path: '/',
      // при необходимости добавьте другие значения по умолчанию
      ...options
    };

    if (options.expires instanceof Date) {
      options.expires = options.expires.toUTCString();
    }

    let updatedCookie = encodeURIComponent(name) + "=" + encodeURIComponent(value);

    for (let optionKey in options) {
      updatedCookie += "; " + optionKey;
      let optionValue = options[optionKey];
      if (optionValue !== true) {
        updatedCookie += "=" + optionValue;
      }
    }

    document.cookie = updatedCookie;
  }

  deleteCookie(name: string) {
    this.setCookie(name, "", {
      'max-age': -1
    })
  }
}
