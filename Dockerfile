FROM python:3.7-slim-buster

COPY ./requirements.txt ./

RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        git \
    ' \
    && apt update -yqq \
    && apt upgrade -yqq \
    && apt install -yqq --no-install-recommends \
        $buildDeps \
        freetds-bin \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
        postgresql \
        libpq-dev \
        mariadb-client \
        default-libmysqlclient-dev \
        gettext-base \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d /airflow airflow \
    && pip install -U pip setuptools wheel \
    && pip install -r requirements.txt \
    && apt purge --auto-remove -yqq $buildDeps \
    && apt autoremove -yqq --purge \
    && apt clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh /entrypoint.sh

RUN chown -R airflow: /airflow

EXPOSE 8080 5555 8793

USER airflow
WORKDIR /airflow
COPY airflow.cfg.tpl ./
COPY ./dags ./dags
