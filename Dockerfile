FROM elixir:1.13.4-alpine as build

RUN apk add --update git build-base nodejs npm yarn python3

RUN mkdir /app
WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

COPY assets/ assets/

RUN mix assets.deploy

COPY priv priv
COPY lib lib
RUN mix compile

RUN mix release

# prepare release image
FROM alpine:3.16 AS app

RUN apk add --update bash openssl postgresql-client
RUN apk add --no-cache ncurses-libs libstdc++
EXPOSE 4000
ENV MIX_ENV=prod

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/kreasidev .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
cmd ["bash", "/app/entrypoint.sh"]
