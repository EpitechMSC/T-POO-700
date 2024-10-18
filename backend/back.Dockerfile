FROM bitwalker/alpine-elixir-phoenix:latest AS phx-builder

# Set exposed ports

RUN apk add --update alpine-sdk

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest

FROM bitwalker/alpine-elixir:latest

EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

COPY --from=phx-builder /opt/app/_build /opt/app/_build
COPY --from=phx-builder /opt/app/priv /opt/app/priv
COPY --from=phx-builder /opt/app/config /opt/app/config
COPY --from=phx-builder /opt/app/lib /opt/app/lib
COPY --from=phx-builder /opt/app/deps /opt/app/deps
# COPY --from=phx-builder /opt/app/.mix /opt/app/.mix
COPY --from=phx-builder /opt/app/mix.* /opt/app/

# alternatively you can just copy the whole dir over with:
# COPY --from=phx-builder /opt/app /opt/app
# be warned, this will however copy over non-build files

# USER default

CMD ["mix", "phx.server"]
