FROM node:latest
LABEL description="Ebonex OpenAPI."
WORKDIR /ebonex-openapi
COPY * /ebonex-openapi/
RUN npm install -g docsify-cli@latest
EXPOSE 3000/tcp
ENTRYPOINT docsify serve .