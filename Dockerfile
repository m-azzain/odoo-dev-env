ARG PGHOST
ARG PGDATABASE
ARG DATABASE_URL
ARG PGUSER
ARG PGPORT
ARG PGPASSWORD

ARG PORT

# FROM python:3.8.10-slim
FROM moh3azzain/odoo-dev-env:test

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

ENV HOST=$PGHOST
ENV USER=$PGUSER
ENV PASSWORD=$PGPASSWORD
ENV DATABASE=$PGDATABASE
ENV DBPORT=$PGPORT

ENV HTTPPORT=$PORT

# Copy Odoo configuration file
COPY ./odoo-dev-env/odoo.conf /etc/odoo/

RUN useradd -rm -d /home/odoo -s /bin/bash -G sudo odoo

RUN chown odoo /etc/odoo/odoo.conf && mkdir -p /var/lib/odoo && chown odoo /var/lib/odoo

# Set default user when running the container
USER odoo

WORKDIR /home/odoo/app

# Copy odoo source code 
# This will actually be overriden by the mount in the docker compose
# COPY ./odoo/ /home/odoo/app 

COPY ./odoo-dev-env/wait-for-psql.py /usr/local/bin/wait-for-psql.py
# Copy the entrypoint file
COPY ./odoo-dev-env/entrypoint.sh /home/odoo



VOLUME ["/var/lib/odoo"]

# Expose Odoo services
# EXPOSE 8069 8071 8072
EXPOSE ${HTTPPORT:-8069}

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf



ENTRYPOINT ["/home/odoo/entrypoint.sh"]
CMD ["odoo"]

