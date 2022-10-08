FROM centos:7
ENV ELASTICSEARCH_VERSION=7.12.1
ENV ELASTICSEARCH_USER=es
RUN adduser $ELASTICSEARCH_USER
RUN \
  yum install -y wget perl-Digest-SHA && \
  yum clean all && \
  rm -rf /var/cache
RUN install -o $ELASTICSEARCH_USER -g $ELASTICSEARCH_USER -d /var/lib/elasticsearch
USER $ELASTICSEARCH_USER
WORKDIR /home/$ELASTICSEARCH_USER
RUN \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  rm -f elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz*
RUN \
  sed -i 's/^#node.name.*/node.name: \${NODENAME}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  sed -i 's/^#path.data.*/path.data: \${PATHDATA}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  echo 'http.bind_host: 0.0.0.0' >> elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["elasticsearch-${ELASTICSEARCH_VERSION}/bin/elasticsearch"]