# Base image
FROM ubuntu:16.04

# Information
LABEL maintainer="FrozenFOXX <siliconfoxx@gmail.com>"

# Variables
ENV PGDATABASE=schemaverse
ENV PGPORT=5432
ENV PGHOST=localhost
ENV PGUSER=schemaverse
ENV SCHEMAVERSESLEEPTIME=60

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        git \
        perl \
        postgresql \
        postgresql-client \
        postgresql-server-dev-all

# Add the user and groups appropriately
RUN addgroup --system schemaverse && \
    adduser --system --home /src/schemaverse --shell /bin/bash --group schemaverse

# Clone down Schemaverse
WORKDIR /src
RUN git clone https://github.com/Abstrct/Schemaverse.git schemaverse
COPY conf/sqitch.conf /src/schemaverse/schema/
COPY scripts/start_schemaverse.sh /src/schemaverse/

# Deploy Schemaverse
RUN sed -i "s/^#listen_addresses.*\=.*'localhost/listen_addresses = '\*/g" /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/postgresql.conf && \
    echo "host schemaverse all 0.0.0.0/0 md5" >> /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/pg_hba.conf && \
    /etc/init.d/postgresql start && \
    cpan App::Sqitch DBD::Pg && \
    su - postgres -c 'createuser schemaverse && createdb -O schemaverse schemaverse' && \
    su - postgres -c 'cd /src/schemaverse/schema && sqitch deploy db:pg:schemaverse' && \
    /etc/init.d/postgresql stop

# Expose ports
EXPOSE 5432

# Run Schemaverse
CMD [ "/src/schemaverse/start_schemaverse.sh" ]