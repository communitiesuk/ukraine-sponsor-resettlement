# Build compilation image
FROM ruby:3.1.4-alpine3.18

# The application runs from /app
WORKDIR /app

# Add the timezone as it's not configured by default in Alpine
RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Europe/London /etc/localtime && echo "Europe/London" > /etc/timezone

RUN apk add --no-cache build-base yarn postgresql-dev bash gcompat
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN gem install bundler:2.3.22 --no-document && \
  bundle install && \
  yarn install

COPY . /app

RUN RAILS_ENV=${RAILS_ENV} INSTANCE_NAME=${INSTANCE_NAME} bundle exec rake assets:precompile

ENV PORT=8080

CMD RAILS_ENV=${RAILS_ENV} rm -f /app/tmp/pids/server.pid && bundle exec rails s -e ${RAILS_ENV} -p ${PORT} --binding=0.0.0.0

EXPOSE ${PORT}


