# ---- Build stage ----
FROM golang:1.22 AS builder

WORKDIR /app

# Copy module files first (to leverage caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source
COPY . .

# Build the Go binary
RUN go build -o backend3

# ---- Run stage ----
FROM gcr.io/distroless/base-debian12

WORKDIR /app
COPY --from=builder /app/backend3 .

EXPOSE 8080
CMD ["./backend3"]
