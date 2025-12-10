# Stage 1: Build the application
FROM node:16-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application from a lightweight web server
FROM nginx:alpine
# Copy the built assets from the builder stage
COPY --from=builder /app/build/ /usr/share/nginx/html/build
COPY --from=builder /app/index.html /usr/share/nginx/html/
COPY --from=builder /app/demo.png /usr/share/nginx/html/
COPY --from=builder /app/decoder-page.jpeg /usr/share/nginx/html/

# Expose port 80 for the web server
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
