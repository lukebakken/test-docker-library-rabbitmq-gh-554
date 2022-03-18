FROM rabbitmq-gh-554:latest
COPY --chown=rabbitmq:rabbitmq 99-rabbitmq.conf /etc/rabbitmq/conf.d/
