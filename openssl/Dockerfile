FROM alpine/openssl

WORKDIR /app

ENV DH="${DH:-FALSE}"

COPY ./run.sh /app/run.sh

CMD /app/run.sh
