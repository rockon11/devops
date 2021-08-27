FROM ruby:2.7

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y install libqt4-dev
RUN gem install puma foreman
RUN mkdir -p app

WORKDIR /opt/devops-test
RUN bundle install

EXPOSE  3000
CMD ["bundle", "exec"]
