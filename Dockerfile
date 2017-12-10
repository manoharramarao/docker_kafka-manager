FROM java:openjdk-8-jre

#ENV DEBIAN_FRONTEND noninteractive
#ENV SCALA_VERSION 2.11
#ENV KAFKA_VERSION 2.11.1.0.0
#ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV TOOLS=/tools
#ENV ZK=zookeeper
#ENV KK=kafka
ENV KM=kafka_manager


RUN apt-get update
RUN apt-get install -y supervisor dnsutils
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# Create installation directories
RUN mkdir -p ${TOOLS}/${KM}

# Install kafka manager
WORKDIR ${TOOLS}/${KM}
COPY kafka-manager-1.3.3.15.zip .
RUN unzip kafka-manager-1.3.3.15.zip
RUN rm kafka-manager-1.3.3.15.zip

ADD scripts/start-kafka-manager.sh /usr/bin/start-kafka-manager.sh
RUN chmod 777 /usr/bin/start-kafka-manager.sh

ADD supervisor/kafka-manager.conf /etc/supervisor/conf.d/

# 9050 - kafka-manager server port
EXPOSE 9050

CMD ["supervisord", "-n"]