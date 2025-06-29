FROM golang:1.24 AS builder
WORKDIR /build
COPY web-server/* /build/
RUN go build -o todoist-oauth-receiver ./...


FROM debian:bookworm
RUN apt-get update && apt-get install -y httpie curl
COPY ./install-charm-repo.sh /opt/install-charm-repo.sh
RUN chmod +x /opt/install-charm-repo.sh && /opt/install-charm-repo.sh
RUN apt-get update && apt-get install -y gum
ENV APP_DIR=/opt/todoist-webhook-setup
WORKDIR ${APP_DIR}
COPY ./todoist-webhook-setup.sh ${APP_DIR}/todoist-webhook-setup.sh
COPY --from=builder /build/todoist-oauth-receiver /usr/bin/todoist-oauth-receiver
CMD [ "./todoist-webhook-setup.sh" ]