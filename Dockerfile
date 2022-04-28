FROM ruby:2.7.4-buster as base

# -------------
# for Ruby
# -------------

ENV RUBY_MAJOR 2.7
ENV RUBY_VERSION 2.7.4

ENV PATH "/.nodenv/bin:/.nodenv/shims:$PATH"
ENV NODENV_ROOT "/.nodenv"

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH=/app/bin:$GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH

RUN apt-get update \
  &&  apt-get install -y --allow-change-held-packages \
  locales \
  vim \
  cmake \
  gconf-service \
  glib-networking \
  fonts-liberation \
  libgtk-3-0 \
  libappindicator1 \
  libappindicator3-1 \
  graphviz \
  && locale-gen ja_JP.UTF-8 \
  && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc \
  && echo "set mouse-=a" >> /root/.vimrc \
  && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# -------------
# for Node
# -------------

RUN git clone https://github.com/nodenv/nodenv.git /.nodenv

RUN mkdir -p "$(nodenv root)"/plugins

RUN git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build

RUN nodenv install 16.13.1

RUN nodenv global 16.13.1

RUN npm install -g yarn

RUN nodenv rehash

# # -------------
# # for chronicle base
# # -------------

# ENV PATH "/app/node_modules/.bin:$PATH"

# RUN mkdir /packages

# WORKDIR /app

# COPY Gemfile* /app/

# ENV LANG C.UTF-8
# ENV EDITOR vim

# RUN apt-get update \
#   &&  apt-get install -y --allow-change-held-packages \
#   locales \
#   vim \
#   cmake \
#   gconf-service \
#   glib-networking \
#   fonts-liberation \
#   libgtk-3-0 \
#   libappindicator1 \
#   libappindicator3-1 \
#   graphviz \
#   && locale-gen ja_JP.UTF-8 \
#   && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc \
#   && echo "set mouse-=a" >> /root/.vimrc \
#   && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
#   && apt-get clean \
#   && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# RUN bundle config set without 'development test'
# RUN bundle install --jobs=4 --retry=3 \
#   && rm Gemfile*

# # -------------
# # for chronicle staging
# # install chromium
# # -------------
# FROM base as install_chromium

# RUN apt-get update \
#   &&  apt-get install -y --force-yes \
#   chromium \
#   &&  apt-get clean \
#   &&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# # COPY Gemfile* /app/

# # RUN echo "require 'webdrivers'; load 'webdrivers/Rakefile'" > Rakefile \
# #   && bundle install --with development test --jobs=4 --retry=3 \
# #   && bundle exec rake webdrivers:chromedriver:update \
# #   && rm Rakefile Gemfile*

# # -------------
# # for chronicle development
# # -------------
# FROM install_chromium as dev

# COPY Gemfile* /app/

# RUN bundle config unset without
# RUN bundle config set with 'development test'
# RUN bundle install --jobs=4 --retry=3 \
#   && rm Gemfile*

# # COPY package.json /app/
# # COPY yarn.* /app/

# # RUN yarn install

# # RUN rm package.json yarn.*
