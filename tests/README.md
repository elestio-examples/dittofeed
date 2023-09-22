<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# DittoFeed, verified and packaged by Elestio

[DittoFeed](https://github.com/dittofeed/dittofeed)The first open-source customer engagement platform built for developers.

<img src="https://github.com/elestio-examples/dittofeed/raw/main/dittofeed.png" alt="plane" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/dittofeed">fully managed DittoFeed</a> on <a target="_blank" href="https://elest.io/">elest.io</a> Automate communications with customers. Give data control to your growth engineers.

[![deploy](https://github.com/elestio-examples/dittofeed/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/dittofeed)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/dittofeed.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:6943`

## Docker-compose

Here are some example snippets to help you get started creating a container.

version: "3.3"
x-database-credentials: &database-credentials
  DATABASE_USER: ${DATABASE_USER}
  DATABASE_PASSWORD: ${DATABASE_PASSWORD}
x-clickhouse-credentials: &clickhouse-credentials
  CLICKHOUSE_USER: ${CLICKHOUSE_USER}
  CLICKHOUSE_PASSWORD: ${CLICKHOUSE_PASSWORD}
x-backend-app-env: &backend-app-env
  <<: [*clickhouse-credentials, *database-credentials]
  NODE_ENV: production
  DATABASE_HOST: ${DATABASE_HOST}
  DATABASECLICKHOUSE_HOST_PORT: ${DATABASE_PORT}
  CLICKHOUSE_HOST: ${CLICKHOUSE_HOST}
  TEMPORAL_ADDRESS: ${TEMPORAL_ADDRESS}
  DASHBOARD_API_BASE: ${DASHBOARD_API_BASE}
services:
  dashboard:
    image: elestio4test/dittofeed-dashboard:${SOFTWARE_VERSION_TAG}
    ports:
      - "172.17.0.1:6943:3000"
    depends_on:
      - postgres
      - temporal
      - api
    environment:
      <<: *backend-app-env
  api:
    image: dittofeed/dittofeed-api:${SOFTWARE_VERSION_TAG}
    ports:
      - "172.17.0.1:6944:3001"
    depends_on:
      - postgres
      - temporal
      - worker
    environment:
      <<: *backend-app-env
  worker:
    image: dittofeed/dittofeed-worker:${SOFTWARE_VERSION_TAG}
    depends_on:
      - postgres
      - temporal
    environment:
      <<: *backend-app-env
  admin-cli:
    image: dittofeed/dittofeed-admin-cli:${SOFTWARE_VERSION_TAG}
    entrypoint: []
    command: tail -f /dev/null
    tty: true
    depends_on:
      - postgres
      - temporal
      - clickhouse-server
    environment:
      <<: *backend-app-env
  temporal:
    depends_on:
      - postgres
    environment:
      - DB=postgresql
      - DB_PORT=${DATABASE_PORT}
      - POSTGRES_USER=${DATABASE_USER}
      - POSTGRES_PWD=${DATABASE_PASSWORD}
      - POSTGRES_SEEDS=${DATABASE_HOST}
      - DYNAMIC_CONFIG_FILE_PATH=config/dynamicconfig/prod.yaml
    image: temporalio/auto-setup:${TEMPORAL_VERSION}
    labels:
      kompose.volume.type: configMap
    ports:
      - 172.17.0.1:7233:7233
    volumes:
      - ./packages/backend-lib/temporal-dynamicconfig:/etc/temporal/config/dynamicconfig
  postgres:
    image: elestio/postgres:15
    restart: always
    environment:
      - POSTGRES_PASSWORD=${DATABASE_PASSWORD}
      - POSTGRES_USER=${DATABASE_USER}
      - POSTGRES_DB=dittofeed
    ports:
      - "172.17.0.1:2632:5432"
    volumes:
      - ./postgres:/var/lib/postgresql/data
  clickhouse-server:
    image: clickhouse/clickhouse-server:22.9.5.25-alpine
    environment:
      <<: *clickhouse-credentials
    ports:
      - "172.17.0.1:8123:8123"
      - "172.17.0.1:9000:9000"
      - "172.17.0.1:9009:9009"
    volumes:
      - ./clickhouse_lib:/var/lib/clickhouse
      - ./clickhouse_log:/var/log/clickhouse-server

  pgadmin4:
    image: dpage/pgadmin4:latest
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
      PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
      PGADMIN_LISTEN_PORT: 8080
    ports:
      - "172.17.0.1:8160:8080"
    volumes:
      - ./servers.json:/pgadmin4/servers.json


# Maintenance

## Logging

The Elestio DittoFeed Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/dittofeed/dittofeed">DittoFeed Github repository</a>

- <a target="_blank" href="https://docs.dittofeed.com/introduction">DittoFeed documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/dittofeed">Elestio/DittoFeed Github repository</a>
