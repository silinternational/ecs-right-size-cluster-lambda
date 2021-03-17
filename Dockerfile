FROM golang:latest

# Install packages
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y git nodejs

WORKDIR /src

# Copy in source and install deps
COPY ./package.json .
RUN npm install -g serverless && npm install
COPY ./ .
RUN go get ./...
