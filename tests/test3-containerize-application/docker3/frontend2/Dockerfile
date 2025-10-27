# Use Nginx Alpine as the base image
FROM nginx:alpine

# Copy the Flutter build output to Nginx's document root
COPY build/web /usr/share/nginx/html

# The base image already exposes port 80 and starts Nginx