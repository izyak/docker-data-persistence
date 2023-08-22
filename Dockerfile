# Use a base image from a suitable repository
FROM alpine:latest

# Set metadata for the image
LABEL maintainer="izyak"
LABEL description="Learn about docker volume mounting. This script stores data in a file, and uses that to make a http request. The data needs to be persistent."

# Install necessary packages or dependencies
RUN apk update && \
    apk add gcc bash curl

# Set the working directory inside the container
WORKDIR /app

# Copy your application files into the container
COPY . /app
RUN mkdir -p data
RUN chmod +x myscript.sh
RUN chmod +x process.sh

# Expose a port if your application listens on a specific port
# EXPOSE 8080

# Define the command to run when the container starts
ENTRYPOINT ["bash", "process.sh"]
