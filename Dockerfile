FROM rclone/rclone:latest

RUN mkdir -p /{cache,data} || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5572

ENTRYPOINT ["/entrypoint.sh"]
