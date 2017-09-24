# Base image
FROM ubuntu:16.04

# Add the user and groups appropriately
RUN addgroup --system schemaadmin && \
    adduser --system --home /home/schemaadmin --shell /bin/bash --group schemaadmin

# Prep environment
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git build-essential perl postgresql postgresql-client postgresql-server-dev-all && \
    /etc/init.d/postgresql start && \
    su - postgres -c 'createuser schemaadmin && createdb -O schemaadmin schemaverse' && \
    cpan App::Sqitch DBD::Pg

# Clone down Schemaverse
WORKDIR /src
RUN git clone https://github.com/Abstrct/Schemaverse.git schemaverse
COPY conf/sqitch.conf /src/schemaverse/schema/

# Deploy Schemaverse
USER postgres
RUN cd schemaverse/schema && \
    sqitch deploy db:pg:schemaverse

