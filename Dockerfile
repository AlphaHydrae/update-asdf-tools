FROM bats/bats:v1.4.1

RUN apk add --no-cache make parallel && \
    adduser -D -s /bin/bash uat

USER uat:uat

COPY ./ /code/

ENTRYPOINT [ "/usr/bin/make" ]
