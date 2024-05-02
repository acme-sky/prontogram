FROM jolielang/jolie

EXPOSE 8000

RUN wget https://jdbc.postgresql.org/download/postgresql-42.7.3.jar && \
    mv postgresql-42.7.3.jar /usr/lib/jolie/lib/jdbc-postgresql.jar

COPY pronto.iol .

COPY server.ol .

COPY RestHandler.ol .

COPY rest_template.json .

COPY config.json .

#RUN jolier server.ol WebPort localhost:8000 -headerHandler
