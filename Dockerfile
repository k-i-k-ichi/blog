FROM ruby:2.7.1-alpine3.1
# some heavy inspiration from https://github.com/envygeeks/jekyll-docker/blob/master/repos/jekyll/Dockerfile

RUN apk add --no-cache build-base gcc bash cmake git

RUN bundle install

# EXPOSE 4000

# WORKDIR /site

# ENTRYPOINT [ "jekyll" ]

# CMD [ "--help" ]


# COPY docker-entrypoint.sh /usr/local/bin/

# # on every container start, check if Gemfile exists and warn if it's missing
# ENTRYPOINT [ "docker-entrypoint.sh" ]

# CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]
