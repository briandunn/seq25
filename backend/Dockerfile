FROM ruby:2.2.10

# debian jessie is EOL and gone from the live mirrors; repoint at the archive.
RUN sed -i \
      -e 's|deb.debian.org|archive.debian.org|g' \
      -e 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' \
      /etc/apt/sources.list \
    && sed -i '/jessie-updates/d' /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
      libpq-dev \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .
# ruby:2.2.2 is no longer pullable (schema v1 manifest); 2.2.10 is the
# newest same-minor image, so relax the exact patch pin for this build only.
RUN sed -i "s/ruby '2.2.2'/ruby '2.2.10'/" Gemfile
RUN bundle install

EXPOSE 3000

CMD ["sh", "-c", "bundle exec thin start --address 0.0.0.0 --port ${PORT:-3000}"]
