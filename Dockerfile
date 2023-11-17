FROM golang:1.21

RUN curl -o- -L https://slss.io/install | VERSION=3.37.0 bash && \
  mv $HOME/.serverless/bin/serverless /usr/local/bin && \
  ln -s /usr/local/bin/serverless /usr/local/bin/sls

WORKDIR /src
COPY ./ .
RUN go get ./...
