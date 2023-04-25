FROM golang:latest

WORKDIR /app

# Copy the local package files to the container's workspace.
COPY ./test-app .

# Build 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/ops-test-app

EXPOSE 8080

ENTRYPOINT ["go", "run", "cmd/ops-test-app/main.go"]