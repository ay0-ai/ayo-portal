# syntax=docker/dockerfile:1.2
# Uses frappe_docker's layered build pattern.
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

RUN bench init \
  --frappe-branch=${FRAPPE_VERSION} \
  --no-procfile --no-backups \
  --skip-redis-config-generation \
  /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

# Copy pre-packaged app source (tarball excludes .git, node_modules)
ADD --chown=frappe:frappe repo_exclude_cache.tar.gz apps/erpnext/

# bench get-app requires a git repo — initialize one from the extracted source
# bench get-app requires a git repo and prompts if app dir exists — set up git, then install directly
RUN cd apps/erpnext && git init && git config user.email "build@ayo.ai" && git config user.name "build" && git add -A && git commit -m "build" --quiet && cd ../.. && \
    ./env/bin/pip install --quiet -e apps/erpnext && \
    echo "" >> sites/apps.txt && echo "erpnext" >> sites/apps.txt && \
    bench build --production

# Stage 2: Runtime
FROM frappe/base:${FRAPPE_VERSION}

COPY --from=builder /home/frappe/frappe-bench /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

EXPOSE 8000 8080 9000
