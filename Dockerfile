# Uses frappe_docker's layered build pattern:
# frappe/build (has compilers) -> build apps -> copy into frappe/base (runtime only)
#
# One image, multiple roles — differentiated by command at deploy time:
#   backend:   gunicorn (default CMD)
#   worker:    bench worker --queue short,default,long
#   scheduler: bench schedule
#   websocket: node apps/frappe/socketio.js
#   frontend:  nginx-entrypoint.sh

ARG FRAPPE_VERSION=develop

# Stage 1: Build
FROM frappe/build:${FRAPPE_VERSION} AS builder

ARG APPS_JSON_BASE64
RUN if [ -n "$APPS_JSON_BASE64" ]; then \
      echo "$APPS_JSON_BASE64" | base64 -d > /opt/frappe/apps.json; \
    fi

RUN bench init \
  --frappe-branch=${FRAPPE_VERSION} \
  --apps_path=/opt/frappe/apps.json \
  --no-procfile --no-backups \
  --skip-redis-config-generation \
  /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

RUN bench build --production && \
    # Strip .git dirs to reduce image size
    find apps -mindepth 1 -path "*/.git" -exec rm -rf {} + 2>/dev/null; true

# Stage 2: Runtime
FROM frappe/base:${FRAPPE_VERSION}

COPY --from=builder /home/frappe/frappe-bench /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

EXPOSE 8000 8080 9000
