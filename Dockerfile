FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

# CMD mix deps.get && mix phx.server

ADD _build/dev/rel/ /rel/

ENTRYPOINT ["/rel/kreasidev/bin/kreasidev", "start"]

