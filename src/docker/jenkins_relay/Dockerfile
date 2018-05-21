FROM elixir:1.6.5

COPY . /app

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force && mix deps.get

ENV MIX_ENV prod

EXPOSE 8080

CMD ["mix", "run", "--no-halt"]