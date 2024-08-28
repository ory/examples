import { Routes } from '@angular/router';
import { NotFoundComponent } from './not-found/not-found.component';
import { ErrorComponent } from './error/error.component';
import { LayoutComponent } from './layout/layout.component';
import { LineChartComponent } from './line-chart/line-chart.component';
import { authGuard } from './auth.guard';

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
                component: LineChartComponent
            }
        ]
    },
    {
        path: '**',
        component: NotFoundComponent
    },
];
