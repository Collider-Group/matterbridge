FROM alpine:edge AS builder

COPY . /go/src/matterbridge
RUN apk --no-cache add go git
WORKDIR /go/src/matterbridge
RUN go build -mod vendor -o /bin/matterbridge

FROM python:alpine
RUN apk --no-cache add ca-certificates mailcap
RUN apk --update add libxml2-dev libxslt-dev libffi-dev gcc musl-dev libgcc openssl-dev curl
RUN apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev
RUN apk add --no-cache --virtual .pynacl_deps build-base python3-dev py3-pip
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir lottie cairosvg
COPY --from=builder /bin/matterbridge /bin/matterbridge
RUN mkdir /etc/matterbridge \
  && touch /etc/matterbridge/matterbridge.toml \
  && ln -sf /matterbridge.toml /etc/matterbridge/matterbridge.toml
ENTRYPOINT ["/bin/matterbridge", "-conf", "/etc/matterbridge/matterbridge.toml"]
