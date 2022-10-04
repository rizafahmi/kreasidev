#!/bin/bash
DB_USER=${DATABASE_USER:-postgres}

# wait until Postgres is ready
while ! pg_isready -q -h db -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/kreasidev"
eval "$bin eval \"Kreasidev.Release.migrate\""
# start the elixir application
echo "Starting..."
exec "$bin" "start"
