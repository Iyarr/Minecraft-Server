FROM openjdk:8-jdk-slim AS build

RUN apt update && \
    apt install -y git

WORKDIR /src

RUN git clone https://github.com/CloudburstMC/Nukkit

WORKDIR /src/Nukkit

RUN git submodule update --init && \
    ./gradlew shadowJar

FROM ubuntu:latest

RUN apt clean && apt update && \
    \
    # terraform のインストール手順
    apt install -y unzip zip git && \
    \
    #tfenvのインストール
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv

ENV PATH="/root/.tfenv/bin:$PATH"

    #tfenv install latestで使用するcurlコマンドをインストール
RUN apt install -y curl && \
    tfenv install latest && \
    tfenv use latest

    # ansible のインストール手順
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Etc/UTC" > /etc/timezone && \
    apt install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt update && \
    apt install software-properties-common -y && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install ansible -y

    # awscli の設定
RUN apt install awscli -y

RUN mkdir /root/.ssh && \
    ssh-keygen -t rsa -N "" -f "$SSH_KEY_PATH"

COPY ./init.sh /src/
RUN chmod +x /src/init.sh


COPY --from=build /src/Nukkit/target/nukkit-1.0-SNAPSHOT.jar /home/nukkit.jar
CMD ["/src/init.sh"]
