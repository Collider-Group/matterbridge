FROM alpine:edge AS builder

COPY . /go/src/matterbridge
RUN apk --no-cache add go git
WORKDIR /go/src/matterbridge
RUN go build -mod vendor -o /bin/matterbridge

FROM alpine
RUN apk --no-cache add ca-certificates mailcap
COPY --from=builder /bin/matterbridge /bin/matterbridge
RUN mkdir /etc/matterbridge \
  && touch /etc/matterbridge/matterbridge.toml \
  && ln -sf /matterbridge.toml /etc/matterbridge/matterbridge.toml
ENTRYPOINT ["/bin/matterbridge", "-conf", "/etc/matterbridge/matterbridge.toml"]
