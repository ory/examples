import { Routes } from '@angular/router';
import { NotFoundComponent } from './not-found/not-found.component';
import { ErrorComponent } from './error/error.component';
import { LayoutComponent } from './layout/layout.component';
import { authGuard } from './auth.guard';
import { AddPointComponent } from './add-point/add-point.component';

export const routes: Routes = [
    {
        path: 'error',
        component: ErrorComponent
    },
    {
        path: '',
        component: LayoutComponent,
        canActivate: [authGuard],
        children: [
            {
                path: '',
                component: AddPointComponent
            }
        ]
    },
    {
        path: '**',
        component: NotFoundComponent
    },
];