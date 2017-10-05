# Base image
FROM ubuntu:16.04

# Information
LABEL maintainer="FrozenFOXX <siliconfoxx@gmail.com>"

# Variables
ENV PGDATABASE=schemaverse
ENV PGPORT=5432
ENV PGHOST=localhost
ENV PGUSER=schemaverse
ENV SCHEMAVERSESLEEP=60

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        git \
        perl \
        postgresql \
        postgresql-client \
        postgresql-server-dev-all && \
    rm -rf /var/lib/apt/lists/*

# Add the user and groups appropriately
RUN addgroup --system schemaverse && \
    adduser --system --home /src/schemaverse --shell /bin/bash --group schemaverse

# Clone down Schemaverse
WORKDIR /src
RUN git clone https://github.com/Abstrct/Schemaverse.git schemaverse
COPY conf/sqitch.conf /src/schemaverse/schema/
COPY scripts/* /src/schemaverse/scripts/

# Deploy Schemaverse
RUN sed -i "s/^#listen_addresses.*\=.*'localhost/listen_addresses = '\*/g" /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/postgresql.conf && \
    sed -i "/^host.*all.*all.*127\.0\.0\.1\/32.*md5$/s/md5/trust/g" /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/pg_hba.conf && \
    sed -i "/^host.*all.*all.*::1\/128.*md5$/s/md5/trust/g" /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/pg_hba.conf && \
    echo "host schemaverse +players ::/0 md5" >> /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/pg_hba.conf && \
    echo "host schemaverse +players 0.0.0.0/0 md5" >> /etc/postgresql/$(ls /etc/postgresql/ | sort -r |head -1)/main/pg_hba.conf && \
    /etc/init.d/postgresql start && \
    cpan App::Sqitch DBD::Pg && \
    su - postgres -c 'createuser -s schemaverse && createdb -O schemaverse schemaverse' && \
    su - postgres -c 'cd /src/schemaverse/schema && sqitch deploy db:pg:schemaverse' && \
    /etc/init.d/postgresql stop

# Expose ports
EXPOSE 5432

# Persistence volume
VOLUME [ "/var/lib/postgresql" ]

# Run Schemaverse
CMD [ "/src/schemaverse/scripts/start_schemaverse.sh" ]
