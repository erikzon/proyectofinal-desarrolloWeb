FROM node:18-alpine 
RUN mkdir -p /app
WORKDIR /app
COPY . .

RUN apk update
RUN apk add g++ 
RUN apk add make
RUN apk add curl
RUN apk add gnupg
RUN apk add python3
RUN apk add unixodbc-dev

# Descarga la clave de autenticación de Microsoft y la almacena
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk || \
    (curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk || \
    (curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk))

RUN curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import -

# Instala el paquete msodbcsql17 aceptando la licencia
RUN apk add --allow-untrusted msodbcsql17_17.10.4.1-1_amd64.apk

RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]

