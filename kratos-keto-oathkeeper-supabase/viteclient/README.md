# Vite Client for Shorts

## Setup

1. Start Ory backend with: `docker-compose up -d` from the root folder
2. Validate all containers to run properly
3. `cp .env.example .env` and setup proper values
4. Test a `Shorts` API : `make apitest`. This should return and print response `200`
5. Run client with: `yarn dev` or `npm start`
