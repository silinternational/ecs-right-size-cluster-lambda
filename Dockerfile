FROM golang:1.19

# Install packages
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

WORKDIR /src

# Copy in source and install deps
COPY ./package.json .
RUN npm install --no-fund -g serverless@3 && npm install --no-fund
COPY ./ .
RUN go get ./...
