Test procedure for https://github.com/docker-library/rabbitmq/issues/554

* Build RabbitMQ image from PR branch
    ```
    git clone https://github.com/lukebakken/rabbitmq-1.git
    cd rabbitmq-1
    git checkout lukebakken/gh-554
    cd 3.9/ubuntu
    docker build --tag rabbitmq-gh-554:latest .
    ```
* Start image and verify that logging is to console
    ```
    docker run --name rabbitmq-gh-554 rabbitmq-gh-554:latest
    ```
* Start shell in image and verify that `RABBITMQ_LOGS` is not set, and expected conf file is present
    ```
    docker exec --interactive --tty rabbitmq-gh-554 /bin/bash

    # erl -sname test -remsh rabbit
    Erlang/OTP 24 [erts-12.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

    Eshell V12.3  (abort with ^G)
    (rabbit@b3db3c1889e2)1> os:getenv("RABBITMQ_LOGS").
    false
    (rabbit@b3db3c1889e2)2>

    root@b3db3c1889e2:/# ls -la /etc/rabbitmq/conf.d
    total 5
    drwxrwxrwx 2 rabbitmq rabbitmq   5 Mar 18 20:28 .
    drwxrwxrwx 3 rabbitmq rabbitmq   4 Mar 18 20:28 ..
    -rw-r--r-- 1 rabbitmq rabbitmq  50 Mar 18 20:24 00-defaults.conf
    -rw-r--r-- 1 rabbitmq rabbitmq 385 Mar 18 20:24 10-default-guest-user.conf
    -rw-r--r-- 1 rabbitmq rabbitmq  50 Mar 18 20:28 management_agent.disable_metrics_collector.conf
    ```
* Build RabbitMQ image using `rabbitmq-gh-554:latest` as a base and enable exchange logging
    ```
    git clone https://github.com/lukebakken//test-docker-library-rabbitmq-gh-554.git
    cd test-docker-library-rabbitmq-gh-554
    docker build --tag rabbitmq-gh-554-custom .
    docker run --name rabbitmq-gh-554-custom rabbitmq-gh-554-custom:latest
    ```

    Expected output like the following. Note the expected `debug` log level as well as indication that the logging exchange started:


    ```
    2022-03-18 20:57:50.300930+00:00 [debug] <0.9.0> Time to start RabbitMQ: 2783195 s
    2022-03-18 20:57:53.638058+00:00 [debug] <0.233.0> Declared exchange 'amq.rabbitmq.log' in vhost '/'
    2022-03-18 20:57:53.638335+00:00 [info] <0.233.0> Logging to exchange 'amq.rabbitmq.log' in vhost '/' ready
    ```
