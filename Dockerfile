FROM ubuntu:14.10
MAINTAINER Frank Lemanschik

RUN add-apt-repository -y ppa:brightbox/ruby-ng \
 && add-apt-repository -y ppa:nginx/stable \
 && apt-get update \
 && apt-get install -y --no-install-recommends vim.tiny wget sudo net-tools pwgen unzip \
logrotate supervisor language-pack-en software-properties-common && \
locale-gen en_US && \
rm -rf /var/lib/apt/lists/* # 20140818
 && apt-get install -y build-essential checkinstall imagemagick nginx apache2 \
      subversion git cvs bzr mercurial ruby2.1 ruby2.1-dev \
      libcurl4-openssl-dev libssl-dev libmagickcore-dev libmagickwand-dev \
      libmysqlclient-dev libpq-dev libxslt1-dev libffi-dev libyaml-dev zlib1g-dev \
 && gem install --no-ri --no-rdoc bundler \
 && rm -rf /var/lib/apt/lists/* # 20140818

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

EXPOSE 80
EXPOSE 443

VOLUME ["/home/redmine/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
