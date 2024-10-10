FROM node:20.12.2-slim

WORKDIR /app
EXPOSE 3000

CMD ["npm", "run", "dev"]
