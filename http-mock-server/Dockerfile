FROM ruby:3.1.2-alpine


RUN gem install sinatra webrick

COPY server.rb .
CMD ruby server.rb -p 8081 -o 0.0.0.0

EXPOSE 8081
