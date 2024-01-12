import { TestBed } from '@angular/core/testing';
import { ActivatedRouteSnapshot, CanActivateFn, RouterStateSnapshot } from '@angular/router';

import { authGuard } from './auth.guard';
import { AuthService } from './auth.service';
import { SaveFutureRedirectService } from './save-future-redirect.service';
import { Observable, of, throwError } from 'rxjs';
import { WindowService } from './window.service';
import { environment } from '../environments/environment';

describe('authGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) => 
      TestBed.runInInjectionContext(() => authGuard(...guardParameters));

  let authService: jasmine.SpyObj<AuthService>;
  let saveFutureRedirectService: jasmine.SpyObj<SaveFutureRedirectService>;
  let windowService: jasmine.SpyObj<WindowService>;
  
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers:[
        {
          provide: AuthService, useValue: jasmine.createSpyObj('AuthService', ['checkAuthenticate'])
        },
        {
          provide: SaveFutureRedirectService, useValue: jasmine.createSpyObj('SaveFutureRedirectService', ['redirectAndClearIfExist','saveIfNotExist'])
        },
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        }
      ]
    });

    

    authService = TestBed.inject(AuthService) as jasmine.SpyObj<AuthService>;
    saveFutureRedirectService = TestBed.inject(SaveFutureRedirectService) as jasmine.SpyObj<SaveFutureRedirectService>;
    windowService = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });

  it('should be true', done => {
    // given (instead of when)

    authService.checkAuthenticate.and.returnValue(of(void 0));

    // when

    (executeGuard({} as ActivatedRouteSnapshot, {} as RouterStateSnapshot) as Observable<boolean>)
      .subscribe({
        next: isSuccess => {
          expect(isSuccess).toEqual(true);
          done();
        }
      });

    // then (instead of verify)

    expect(authService.checkAuthenticate.calls.count())
      .toBe(1);

    expect(saveFutureRedirectService.redirectAndClearIfExist.calls.count())
      .toBe(1);
      

  });

  it('should be false', done => {
    // given (instead of when)

    const error = {
        "error":{
          "redirect_to": "/someroute"
        },
        status: 401
    };


    const window = {
      "location": {
        "href": {}
      }
    }

    authService.checkAuthenticate.and.returnValue(new Observable<void>(s => {
      s.error(error);
      s.complete();
    }));

    windowService.get.and.returnValue(window);

    // when

    (executeGuard({} as ActivatedRouteSnapshot, {} as RouterStateSnapshot) as Observable<boolean>)
      .subscribe({
        next: isSuccess => {
          expect(window.location.href).toEqual(`${environment.apiUrl}${error.error.redirect_to}`);
          expect(isSuccess).toEqual(false);
          done();
        },
        error: error => done.fail('never call')
      });

    // then (instead of verify)

    expect(authService.checkAuthenticate.calls.count())
      .toBe(1);

    expect(saveFutureRedirectService.saveIfNotExist.calls.count())
      .toBe(1);
      

  });


  it('should be false 2', done => {
    // given (instead of when)

    const error = {
        "error":{
          "redirect_to": "/someroute"
        },
        status: 404
    };


    const window = {
      "location": {
        "href": {}
      }
    }

    authService.checkAuthenticate.and.returnValue(new Observable<void>(s => {
      s.error(error);
      s.complete();
    }));

    windowService.get.and.returnValue(window);

    // when

    (executeGuard({} as ActivatedRouteSnapshot, {} as RouterStateSnapshot) as Observable<boolean>)
      .subscribe({
        next: isSuccess => {
          expect(window.location.href).toEqual(`/error`);
          expect(isSuccess).toEqual(false);
          done();
        },
        error: error => done.fail('never call')
      });

    // then (instead of verify)

    expect(authService.checkAuthenticate.calls.count())
      .toBe(1);
      

  });
   
});