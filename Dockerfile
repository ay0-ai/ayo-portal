# Uses frappe_docker's layered build pattern:
# One image, multiple roles — differentiated by command at deploy time:
#   backend:   gunicorn (default CMD)
#   worker:    bench worker --queue short,default,long
#   scheduler: bench schedule
#   websocket: node apps/frappe/socketio.js
#   frontend:  nginx-entrypoint.sh

ARG FRAPPE_VERSION=develop

# Stage 1: Build
FROM frappe/build:${FRAPPE_VERSION} AS builder

ARG FRAPPE_VERSION=develop

# Initialize bench with frappe only
RUN bench init \
  --frappe-branch=${FRAPPE_VERSION} \
  --no-procfile --no-backups \
  --skip-redis-config-generation \
  /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

# Copy our app source directly (avoids private repo clone issues)
COPY --chown=frappe:frappe . apps/erpnext

# Install the app and build assets
RUN bench get-app --skip-assets file:///home/frappe/frappe-bench/apps/erpnext && \
    bench build --production && \
    find apps -mindepth 1 -path "*/.git" -exec rm -rf {} + 2>/dev/null; true

# Stage 2: Runtime
FROM frappe/base:${FRAPPE_VERSION}

COPY --from=builder /home/frappe/frappe-bench /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

EXPOSE 8000 8080 9000
