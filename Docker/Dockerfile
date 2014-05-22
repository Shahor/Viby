FROM debian:wheezy
RUN apt-get update && apt-get install -y ruby ruby-dev bundler libcurl4-openssl-dev vim libsqlite3-dev git
RUN git clone https://github.com/Shahor/Viby
WORKDIR /Viby
RUN bundle install
RUN sed -i '1s/^/Encoding.default_external = Encoding::UTF_8\n/' viby
RUN sed -i '1s/^/Encoding.default_internal = Encoding::UTF_8\n/' viby
RUN cp /Viby/config.yml-dist /Viby/config.yml
