FROM golang:1.19

# Install packages
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

WORKDIR /src

RUN npm --no-fund install -g serverless@3

COPY ./ .
RUN go get ./...
