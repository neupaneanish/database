FROM --platform=$BUILDPLATFORM golang:1.26-alpine AS builder

LABEL authors="neupaneanish"

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags="-s -w" -trimpath -o /database ./cmd/migrate/main.go

FROM gcr.io/distroless/static-debian12 AS server

WORKDIR /

COPY --from=builder /database /database

USER nonroot:nonroot

ENTRYPOINT ["/database"]