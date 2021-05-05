FROM golang:1.16-alpine3.12 AS builder

RUN apk add --no-cache bash gcc git make musl-dev
COPY . $GOPATH/src/github.com/hyperledger/fabric
WORKDIR $GOPATH/src/github.com/hyperledger/fabric

FROM builder AS peer
RUN make peer

FROM alpine:3.12
ENV FABRIC_CFG_PATH /etc/hyperledger/fabric
VOLUME /etc/hyperledger/fabric
VOLUME /var/hyperledger
COPY --from=peer /go/src/github.com/hyperledger/fabric/build/bin /usr/local/bin
COPY --from=peer /go/src/github.com/hyperledger/fabric/sampleconfig/msp ${FABRIC_CFG_PATH}/msp
COPY --from=peer /go/src/github.com/hyperledger/fabric/sampleconfig/core.yaml ${FABRIC_CFG_PATH}
EXPOSE 7051
CMD ["peer","node","start"]