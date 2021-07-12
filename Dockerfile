FROM ruby:2.7.4-alpine3.14
# some heavy inspiration from https://github.com/envygeeks/jekyll-docker/blob/master/repos/jekyll/Dockerfile

RUN apk add --no-cache build-base gcc bash cmake git

# create directory to mount site from host
RUN mkdir -p /blog
VOLUME . /blog

# ENTRYPOINT [ "jekyll" ]

# CMD [ "--help" ]


# COPY docker-entrypoint.sh /usr/local/bin/

# # on every container start, check if Gemfile exists and warn if it's missing
# ENTRYPOINT [ "docker-entrypoint.sh" ]

# CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]
# CMD ["top"]
