# Base image
FROM ubuntu:16.04

# Information
LABEL maintainer="FrozenFOXX <siliconfoxx@gmail.com>"

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
RUN addgroup --system schemaadmin && \
    adduser --system --home /src/schemaverse --shell /bin/bash --group schemaadmin

# Clone down Schemaverse
WORKDIR /src
RUN git clone https://github.com/Abstrct/Schemaverse.git schemaverse
COPY conf/sqitch.conf /src/schemaverse/schema/

# Deploy Schemaverse
RUN /etc/init.d/postgresql start && \
    cpan App::Sqitch DBD::Pg && \
    su - postgres -c 'createuser schemaadmin && createdb -O schemaadmin schemaverse' && \
    su - postgres -c 'cd /src/schemaverse/schema && sqitch deploy db:pg:schemaverse'
