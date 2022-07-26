#!/bin/bash

#Exit immediately if a command exits with a non-zero status
set -e

if [ -v PASSWORD_FILE ]; then
    PASSWORD="$(< $PASSWORD_FILE)"
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file

: ${HOST:=${DB_PORT_5432_TCP_ADDR:="db"}}
: ${DBPORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:="odoo"}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:="odoo"}}}
: ${DATABASE:=${DB_ENV_POSTGRES_DATABASE:=${POSTGRES_DATABASE:="railway"}}}
: ${HTTPPORT:=8069}


DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then       
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" |cut -d " " -f3|sed 's/["\n\r]//g')
    fi;
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}
check_config "db_host" "$HOST"
check_config "db_port" "$DBPORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"
check_config "database" "$DATABASE"
check_config "http-port" "$HTTPPORT"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
#            exec odoo "$@"
            python3 odoo-bin "$@"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
#            exec odoo "$@" "${DB_ARGS[@]}"
            python3 odoo-bin "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
#        exec odoo "$@" "${DB_ARGS[@]}"
        python3 odoo-bin "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
