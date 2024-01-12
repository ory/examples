# **ORY Hydra OAuth2 Example**

## Описание

Пример реализации [OAuth 2.0 Authorization Code with PKCE](https://www.ory.sh/docs/oauth2-oidc/authorization-code-flow) с использованием [ORY Hydra](https://www.ory.sh/hydra/).

Login Flow и Consent Flow реализованы с использованием Spring boot 2(Java 11, WebFlux), Angular 17, PostgreSQL 15.

Все оттестировано: Karma, JUnit 5, Testcontainers.

## Как собрать example Login Flow Wrapper, Consent Flow Wrapper,  OAuth 2.0 Client(s), OAuth 2.0 Resource Server

В качестве примера возьмем Login Flow and Consent Flow Wrapper.

### Build Frontend

path:

```bash
cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-frontend/
```

Если необходимо выполнить тестирование (Karma), то:

```bash
cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-frontend/ && \
npm i && \
bash test_and_report.bash
```

Если необходимо узнать покрытие кода тестами, то необходимо открыть через браузер следующее:

```text
ory_hydra_oauth2_example_authorization_server/authorization/authorization-frontend/coverage/authorization-frontend/index.html
```

Чтобы собрать docker image выполним следующее (ВНИМАНИЕ! Необходимо установить pack. Инструкция внутри build_image.bash):

```bash

# install pack
# https://buildpacks.io/docs/tools/pack/#linux-script-install
# (curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.29.0/pack-v0.29.0-linux.tgz" | sudo tar -C /usr/local/bin/ --no-same-owner -xzv pack)

cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-frontend/ && \
bash build_image.bash
```

### Build Backend

path:

```bash
cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-backend/
```

Если необходимо выполнить тестирование (JUnit 5), то (**ВНИМАНИЕ!** Т.к. для тестирования используется Testcontainers, то необходимы права на запуск docker (sudo usermod -aG docker \[user\])):

```bash
cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-backend/ && \
./gradlew -v && \
bash test_and_report.bash
```

Если необходимо узнать покрытие кода тестами (JaCoCo), то необходимо открыть через браузер следующее:

```text
ory_hydra_oauth2_example_authorization_server/authorization/authorization-backend/build/reports/jacoco/test/html/index.html
```

Чтобы собрать docker image выполним следующее:

```bash
cd ory_hydra_oauth2_example_authorization_server/authorization/authorization-backend/ && \
bash build_image.bash
```

### Proxy

#### Docker (Debian)

```bash
mkdir -p /etc/systemd/system/docker.service.d

# set proxy
cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<-EOF
[Service]
Environment="HTTP_PROXY=http://proxyuser:proxypass@192.168.20.4:8822/"
Environment="HTTPS_PROXY=http://proxyuser:proxypass@192.168.20.4:8822/"
Environment="NO_PROXY=localhost,127.0.0.1"
EOF

# restart docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# check
systemctl show --property=Environment docker

```

#### APT (Docker image)

Если необходимо указать прокси сервер (see ory_hydra_oauth2_example_authorization_server/authorization/authorization-frontend/build_image.bash or ory_hydra_oauth2_example_authorization_server/authorization/authorization-backend/build_image.bash), то раскомментируйте HTTP_PROXY (HTTPS_PROXY or/and NO_PROXY) и отредактируйте HTTP_PROXY (HTTPS_PROXY or/and NO_PROXY)

```bash
 #!/bin/bash

export HTTP_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
export HTTPS_PROXY="http://proxyuser:proxypass@192.168.20.4:8822/"
export NO_PROXY="localhost,127.0.0.1"

REPO_IMAGE="chistousov"
...

```

## Пример

![ory-hydra-oauth2-example](ory-hydra-oauth2-example.png)

4 Debian:
| Type                                           | DNS, Hostname             | IP            |
| -------------                                  | -------------             | ------------- |
| OAuth 2.0 Authorization Server                 | authorization-server.com  | 192.168.0.101 |
| OAuth 2.0 Client (Readonly)                    | client-readonly.com       | 192.168.0.102 |
| OAuth 2.0 Client (Write and read)              | client-write-and-read.com | 192.168.0.103 |
| OAuth 2.0 Resource Server                      | resource-server.com       | 192.168.0.104 |

Требуется openssl, jq (apt install jq), htpasswd (apt install apache2-utils), envsubst для выполнения start.bash.

Требуется на удаленных серверах: Docker, Docker Compose (V3)

Организовываем ssh и согласуем настройки с .env файлом 
```bash
# ------------------!!!EDIT!!!----------------

IP_AUTHORIZATION_SERVER=192.168.0.101
IP_RESOURCE_SERVER=192.168.0.104
IP_CLIENT_READONLY=192.168.0.102
IP_CLIENT_WRITE_AND_READ=192.168.0.103

DNS_AUTHORIZATION_SERVER=authorization-server.com
DNS_RESOURCE_SERVER=resource-server.com
DNS_CLIENT_READONLY=client-readonly.com
DNS_CLIENT_WRITE_AND_READ=client-write-and-read.com

USER_AUTHORIZATION_SERVER=someuser
USER_RESOURCE_SERVER=someuser
USER_CLIENT_READONLY=someuser
USER_CLIENT_WRITE_AND_READ=someuser

USER_DATA_POSTGRESQL_PASSWORD=cklGS7BNMT6Io9Yd8FKzg4ZmWLXjQnA24JbXNHbG

HYDRA_POSTGRESQL_PASSWORD=7pj3gK8arVwk6A1BbUD2XysfIYmKdEk0DL8BMRNx

HYDRA_SECRETS_COOKIE=OT9Z8I2NcBp01rP4FwQG7JEt6nuXeJ0BDpf4Bjwc
HYDRA_SECRETS_SYSTEM=cIsKS4VzJCDpXlwm2PNTb7v60GHh1iEYZPiiPpRS
    
HYDRA_INTROSPECT_USER=user_introspect
HYDRA_INTROSPECT_PASSWORD=hUq7Mw3fr4lFjnHQtoJucgDdAV58NbAOvuGN2OfB

# ------------------------------------------

```

Чтоб узнать ip адрес можно выполнить ***ip a***.

**ВНИМАНИЕ!** Пользователи USER_AUTHORIZATION_SERVER, USER_RESOURCE_SERVER, USER_CLIENT_READONLY и USER_CLIENT_WRITE_AND_READ должны иметь право запускать docker compose (V3) (sudo usermod -aG docker \[user\]).

Запускаем скрипт для конфигурирования четырех серверов:
```bash
bash start.bash
```

### Проверяем

На компьютере Resource Owner ОПИСЫВАЕМ IP АДРЕСА В ФАЙЛЕ /etc/hosts (Linux).

```bash
# Допустим
#DNS_AUTHORIZATION_SERVER=authorization-server.com
#DNS_RESOURCE_SERVER=resource-server.com
#DNS_CLIENT_READONLY=client-readonly.com
#DNS_CLIENT_WRITE_AND_READ=client-write-and-read.com

echo '192.168.0.101 authorization-server.com' >> /etc/hosts
echo '192.168.0.102 client-readonly.com' >> /etc/hosts
echo '192.168.0.103 client-write-and-read.com' >> /etc/hosts
echo '192.168.0.104 resource-server.com' >> /etc/hosts
# check
ping authorization-server.com
ping client-readonly.com
ping client-write-and-read.com
ping resource-server.com
```

0. Регистрируем Resource Owner <https://authorization-server.com/registration>.
1. Заходим на <https://client-readonly.com>.
2. Так как пользоавтель не вошел в систему, то пользователя перебрасывает на <https://authorization-server.com/login> (Login Flow, аутентификация), потом на <https://authorization-server.com/consent> (Consent Flow, авторизация).
3. Далее пользователь попадает обратно на <https://client-readonly.com>.
4. Для получения данных OAuth 2.0 Client (Readonly) обращается на <https://resource-server.com> с access token.

### Stop

Останавливаем контейнеры с сохранением данных (volume).

```bash
bash stop.bash
```

### Stop and clean

Останавливаем контейнеры и удаляем все данные(volume).

```bash
bash stop_and_clean.bash
```