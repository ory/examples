import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';

import { AddPointComponent } from './add-point.component';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { GenerationCookieCsrfService } from '../generation-cookie-csrf.service';
import { AppService } from '../app.service';
import { DebugElement } from '@angular/core';
import { By } from '@angular/platform-browser';
import { of, throwError } from 'rxjs';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { HttpErrorResponse } from '@angular/common/http';

describe('AddPointComponent', () => {
  let generationCookieCsrfServiceSpy: jasmine.SpyObj<GenerationCookieCsrfService>;
  let appServiceSpy: jasmine.SpyObj<AppService>;

  let component: AddPointComponent;
  let fixture: ComponentFixture<AddPointComponent>;

  let hostDe: DebugElement;

  let addButton: HTMLButtonElement;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        AddPointComponent, 
        HttpClientTestingModule,
        NoopAnimationsModule
      ],
      providers: [
        {
          provide: GenerationCookieCsrfService, 
          useValue: jasmine.createSpyObj('GenerationCookieCsrfService', ['generateCookieCsrf'])
        },
        {
          provide: AppService, 
          useValue: jasmine.createSpyObj('AppService', ['change'])
        }
      ]
    })
    .compileComponents()
    
  });

  beforeEach(() => {
    generationCookieCsrfServiceSpy = TestBed.inject(GenerationCookieCsrfService) as jasmine.SpyObj<GenerationCookieCsrfService>;
    appServiceSpy = TestBed.inject(AppService) as jasmine.SpyObj<AppService>;

    fixture = TestBed.createComponent(AddPointComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
    
    hostDe = fixture.debugElement;

    addButton = hostDe.query(By.css("#addButton")).nativeElement;
  });



  it('addValue should be succeed', fakeAsync(() => {
    // given (instead of when)
    
    appServiceSpy.change.and.returnValue(of(1));

    // when

    addButton.click();
    tick(10000);
    
    // then (instead of verify)

    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(appServiceSpy.change.calls.count())
      .withContext("appServiceSpy.change.calls.count() !== 1")
      .toBe(1);

  }));

  it('addValue should be fail (enter)', fakeAsync(() => {
    // given (instead of when)
  
    appServiceSpy.change.and.returnValue(throwError(() => new HttpErrorResponse({status: 404})));

    // when

    window.dispatchEvent(new KeyboardEvent('keydown',{
      key: 'enter'
    }));

    // then (instead of verify)


    expect(generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count())
      .withContext("generationCookieCsrfServiceSpy.generateCookieCsrf.calls.count() !== 1")
      .toBe(1);

    expect(appServiceSpy.change.calls.count())
      .withContext("appServiceSpy.change.calls.count() !== 1")
      .toBe(1);
  }));
});
