import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LayoutComponent } from './layout.component';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { AuthService } from '../auth.service';
import { SaveFutureRedirectService } from '../save-future-redirect.service';
import { WindowService } from '../window.service';
import { of } from 'rxjs';
import { HttpClientTestingModule } from '@angular/common/http/testing';

describe('LayoutComponent', () => {
  let component: LayoutComponent;
  let fixture: ComponentFixture<LayoutComponent>;

  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let authServiceSpy: jasmine.SpyObj<AuthService>;
  let saveFutureRedirectServiceSpy: jasmine.SpyObj<SaveFutureRedirectService>;
  let windowServiceSpy: jasmine.SpyObj<WindowService>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LayoutComponent, HttpClientTestingModule],
      providers: [
        {
          provide: GenerationCookieCsrfService, useValue: jasmine.createSpyObj('GenerationCookieCsrfService', ['generateCookieCsrf'])
        },
        {
          provide: AuthService, useValue: jasmine.createSpyObj('AuthService', ['logout'])
        },
        {
          provide: SaveFutureRedirectService, useValue: jasmine.createSpyObj('SaveFutureRedirectService', ['saveIfNotExist'])
        },
        {
          provide: WindowService, useValue: jasmine.createSpyObj('WindowService', ['get'])
        }
      ]
    })
    .compileComponents();
    
    generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
    authServiceSpy = TestBed.inject(AuthService) as jasmine.SpyObj<AuthService>;
    saveFutureRedirectServiceSpy = TestBed.inject(SaveFutureRedirectService) as jasmine.SpyObj<SaveFutureRedirectService>;
    windowServiceSpy = TestBed.inject(WindowService) as jasmine.SpyObj<WindowService>;

    fixture = TestBed.createComponent(LayoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('logout', () => {

    const window = {
      "location": {
        "href": {}
      }
    }

    generationCookieCsrfServiceSpy.generateCookieCsrf.and.returnValue();

    saveFutureRedirectServiceSpy.saveIfNotExist.and.returnValue();

    windowServiceSpy.get.and.returnValue(window);

    authServiceSpy.logout.and.returnValue(of(void 0));

    component.logout();

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext('generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() == 1')
      .toBe(1);
    expect(saveFutureRedirectServiceSpy.saveIfNotExist.calls.count())
      .withContext('saveFutureRedirectServiceSpy.saveIfNotExist.calls.count() == 2')
      .toBe(2);

  });
});
