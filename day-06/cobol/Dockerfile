FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
  gnucobol \
  make \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
