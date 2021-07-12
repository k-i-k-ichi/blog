FROM ruby:2.7.4-alpine3.14
# some heavy inspiration from https://github.com/envygeeks/jekyll-docker/blob/master/repos/jekyll/Dockerfile

RUN apk add --no-cache build-base gcc bash cmake git

# create directory to mount site from host
RUN mkdir -p /blog

RUN gem install bundler -v "2.2.23"

# TODO: mount Gemfile into image and run bundle install on image creation
# make script to run build static and exit
