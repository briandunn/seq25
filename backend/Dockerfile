FROM ruby:4.0.7

RUN apt-get update && apt-get install -y --no-install-recommends \
      libpq-dev \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# compose.prod.yaml sets this to "development:test".
ARG BUNDLE_WITHOUT=""
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "bundle exec puma --bind tcp://0.0.0.0:${PORT:-3000}"]
