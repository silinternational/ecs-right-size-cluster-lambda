FROM golang:latest

# Install packages
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y git nodejs
RUN go get -u github.com/golang/dep/cmd/dep

# Copy in source and install deps
RUN mkdir -p /go/src/github.com/silinternational/ecs-right-size-cluster-lambda
COPY ./package.json /go/src/github.com/silinternational/ecs-right-size-cluster-lambda/
WORKDIR /go/src/github.com/silinternational/ecs-right-size-cluster-lambda
RUN npm install -g serverless && npm install
COPY ./ /go/src/github.com/silinternational/ecs-right-size-cluster-lambda/
RUN dep ensure
