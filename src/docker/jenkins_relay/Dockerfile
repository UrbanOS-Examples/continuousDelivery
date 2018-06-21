FROM elixir:1.6.5
ENV MIX_ENV test
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix test

FROM elixir:1.6.5
ENV MIX_ENV prod
COPY . /app
WORKDIR /app
EXPOSE 8080
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod
CMD ["mix", "run", "--no-halt"]
