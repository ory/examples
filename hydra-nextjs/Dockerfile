FROM node:16.16-alpine3.16 AS builder

RUN mkdir app
WORKDIR /app

# install dependencies
COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile

# copy code
COPY . .

# build
RUN yarn build

# remove unnecessary files
RUN wget https://gobinaries.com/tj/node-prune && sh node-prune
RUN node-prune

ENTRYPOINT ["yarn", "start"]
CMD []

# -----------------------------------------------------------------------------

FROM node:16.16-alpine3.16

RUN mkdir app
WORKDIR /app

COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.env ./
COPY --from=builder /app/.env.production ./
COPY --from=builder /app/.next ./.next

# run as `nextjs`
RUN addgroup --system --gid 1001 nextjs
RUN adduser --system --uid 1001 nextjs
RUN chown nextjs:nextjs /app
USER nextjs:nextjs

# environment
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
ENV PORT 3000

EXPOSE 3000

ENTRYPOINT ["yarn", "start"]
CMD []
