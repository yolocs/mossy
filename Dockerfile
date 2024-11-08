# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.mod .
COPY go.sum .

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the binary with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags="-w -s" -o cowsay-server .

# Final stage
FROM scratch

# Copy the binary from builder
COPY --from=builder /app/cowsay-server /cowsay-server

# Expose port 8080
EXPOSE 8080

# Run the binary
ENTRYPOINT ["/cowsay-server"]
