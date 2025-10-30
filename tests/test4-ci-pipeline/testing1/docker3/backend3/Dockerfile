# Start from a base image that already has Go installed
# This is like inheriting from a parent - you get Go for free!
FROM golang:1.25

# Set the working directory inside the container
# All subsequent commands will run from /app
# Think of this like doing "cd /app" in a shell
WORKDIR /app

COPY . .

RUN go build -o server

EXPOSE 8080

CMD ["./server"]