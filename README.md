This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.js`. The page auto-updates as you edit the file.

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.js`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.


FROM ubuntu:18.04

RUN apt update -y  &&  apt upgrade -y && apt-get update 
RUN apt install -y curl python3.7 git python3-pip openjdk-8-jdk unixodbc-dev

# Add SQL Server ODBC Driver 17 for Ubuntu 18.04
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

COPY startup.sh /
RUN chmod +x /startup.sh
ENTRYPOINT ["sh","/startup.sh"]



RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc

RUN curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17

RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc





------------
este funciona pero necesita GLIBC_2.29


FROM node:18-buster 
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    curl \
    python3 \
    apt-transport-https \
    unixodbc-dev

# Descarga la clave de autenticación de Microsoft y la almacena
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
# Agrega el repositorio de paquetes de Microsoft a las fuentes de apt
RUN curl curl https://packages.microsoft.com/config/debian/10/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
# Actualiza nuevamente la lista de paquetes después de agregar el repositorio
RUN apt-get update
# Instala el paquete msodbcsql17 aceptando la licencia
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17


RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]



---------------------------------
simplemente no puede resolver packages.microsoft.com (si lo resolvio en la oficina)

FROM node:18-alpine 
RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN apk update
RUN apk add g++ 
RUN apk add make
RUN apk add curl
RUN apk add python3
RUN apk add unixodbc-dev

# Descarga la clave de autenticación de Microsoft y la almacena
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk || \
    (curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk || \
    (curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.4.1-1_amd64.apk))

# Agrega el repositorio de paquetes de Microsoft a las fuentes de apt
RUN curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import -
# Actualiza nuevamente la lista de paquetes después de agregar el repositorio
RUN pg --verify msodbcsql17_17.10.4.1-1_amd64.sig msodbcsql17_17.10.4.1-1_amd64.apk

# Instala el paquete msodbcsql17 aceptando la licencia
RUN sudo apk add --allow-untrusted msodbcsql17_17.10.4.1-1_amd64.apk


RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]



---------CON UBUNTU NO FUNCIONO
# FROM ubuntu:23.04
# RUN mkdir -p /app
# WORKDIR /app
# COPY . .
# RUN apt-get update && \
#     apt-get install -y \
#     g++ \
#     make \
#     curl \
#     python3 \
#     nodejs \
#     npm && \
#     rm -rf /var/lib/apt/lists/*  # Limpia la caché de paquetes para reducir el tamaño de la imagen

# # Descarga la clave de autenticación de Microsoft y la almacena
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc

# # Agrega el repositorio de paquetes de Microsoft a las fuentes de apt
# RUN curl https://packages.microsoft.com/config/ubuntu/23.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

# # Instala el paquete msodbcsql17 aceptando la licencia
# RUN apt-get update
# RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17

# RUN npm install
# RUN npm run build
# EXPOSE 3000
# CMD ["npm", "start"]
