# Nuxt 3 Kratox Selfservice example

## Relevant files

The nuxt integration is very simple and is not based on any modules.
The files used to handle authentication and session checks are

- `composables/useAuth.ts`: Contains the functions to login, logout and check if the user is authenticated.
- `middleware/auth.global.ts`: Checks for a valid kratos session and redirects to the login page if not found.
- `pages/signup.vue` & `pages/login.vue`: The signup and login pages implements with `useAuth`
- `plugins/kratos.ts`: Provide kratos client's to the nuxt app.

## Setup

Make sure to install the dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development Server


```bash
docker compose up -d
```

Then the frontend will be available on http://127.0.0.1:3000. Make sure to use the IP address not `localhost` as it will lead to problems with cookies.
