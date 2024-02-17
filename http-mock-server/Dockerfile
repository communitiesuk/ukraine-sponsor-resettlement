FROM ruby:3.1.4-alpine3.18


RUN gem install sinatra webrick rackup

COPY server.rb .
CMD ruby server.rb -p 8081 -o 0.0.0.0

EXPOSE 8081
