# Étape de build
FROM node:18-alpine AS builder

WORKDIR /app

# Installer les dépendances
COPY package.json package-lock.json ./
RUN npm install

# Copier tout le projet pour le build
COPY . .

# Générer le build de production
RUN npm run build

# Étape de production
FROM node:18-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Copier les fichiers nécessaires depuis le build
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
