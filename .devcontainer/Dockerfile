# .devcontainer/Dockerfile
FROM debian:bookworm

# Avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Copy in the install script
COPY install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh && /tmp/install.sh

EXPOSE 6080 5900
CMD ["/usr/bin/supervisord", "-n"]
