FROM ubuntu:latest

RUN apt clean && apt update && apt upgrade -y && \
    \
    # terraform のインストール手順
    apt install -y unzip zip git curl && \
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

COPY ./ansible /home/ansible
COPY ./tf /home/tf

COPY ./init.sh /src/
RUN sed -i 's/\r//' /src/init.sh
RUN chmod +x /src/init.sh
RUN chmod +x /home/tf/script.sh

WORKDIR /home/tf
CMD ["/bin/bash", "/src/init.sh"]
