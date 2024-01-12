import { TestBed } from '@angular/core/testing';

import { ErrorService } from './error.service';
import { MatSnackBar, MatSnackBarConfig, MatSnackBarRef, TextOnlySnackBar } from '@angular/material/snack-bar';

describe('ErrorService', () => {
  let service: ErrorService;
  let matSnackBarSpy: jasmine.SpyObj<MatSnackBar>;

  beforeEach(() => {
    
    TestBed.configureTestingModule({
      providers: [
        ErrorService,
        {
          provide: MatSnackBar, useValue: jasmine.createSpyObj('MatSnackBar', ['open'])
        }
      ]
    });
    service = TestBed.inject(ErrorService);
    matSnackBarSpy = TestBed.inject(MatSnackBar) as jasmine.SpyObj<MatSnackBar>;

  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
  
  it('handle', () => {
    // given (instead of when)
    
    const expectedArgsOpen: [message: string, action?: string | undefined, config?: MatSnackBarConfig<any> | undefined] = [
      'Some Error',
      service.actionCloseButtonName,
      service.confOptionsSnackbar
    ];

    // when

    service.handle(expectedArgsOpen[0]);

    // then (instead of verify)

    expect(matSnackBarSpy.open.calls.count())
      .toBe(1);
    expect(matSnackBarSpy.open.calls.first().args)
      .toEqual(expectedArgsOpen);
  });

});
