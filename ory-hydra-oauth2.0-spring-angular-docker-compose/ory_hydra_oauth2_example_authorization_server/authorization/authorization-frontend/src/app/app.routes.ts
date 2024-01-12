import { Routes } from '@angular/router';
import { NotFoundComponent } from './not-found/not-found.component';

export const routes: Routes = [
  {
    path: 'error',
    loadComponent: () => import("./error/error.component").then(c => c.ErrorComponent)
  },
  { path: 'registration', loadChildren: () => import('./registration/registration.module').then(m => m.RegistrationModule) },
  {
    path: '',
    redirectTo: '/registration',
    pathMatch: 'full'
  },
  {
    path: 'login',
    loadComponent: () => import("./login/login.component").then(c => c.LoginComponent)
  },
  {
    path: 'consent',
    loadComponent: () => import("./consent/consent.component").then(c => c.ConsentComponent)
  },
  {
    path: "logout/request",
    loadComponent: () => import("./logout-request/logout-request.component").then(c => c.LogoutRequestComponent)
  },
  {
    path: "logout/:status",
    loadComponent: () => import("./logout-handled/logout-handled.component").then(c => c.LogoutHandledComponent)
  },
  {
    path: '**',
    component: NotFoundComponent
  }
];
