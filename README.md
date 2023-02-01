# Chillbillies PHP Development Environment
Heard PHP was a legacy language? Think again. This development environment is powered by the modern app server [FrankenPHP](https://frankenphp.dev) bundled with all the services needed to quickly get a [Symfony](https://symfony.com) project off the ground.
This unique dev stack has been dubbed **PRPLM** (PHP, Redis, Postgres, powered by Linux... also Mailhog). A more technical breakdown is as follows:
- PHP 8.2 with `composer`, `symfony`, LTS NodeJS and `yarn`
- Two PostgreSQL v15 databases for development and testing
- Redis 7.05
- MailHog (local mail server)

 The goal is to take the arduous process of environment setup and boil it down to a simple, reproducible process by leveraging [Docker](https://www.docker.com/).

## Prerequisites
- [Docker Desktop](https://www.docker.com/)

## Get Started
1. Fill in the app name in `docker/.env`, whether you want to "init" a new project or not, and optional host ports.
2. While in this directory, run `docker compose build`
3. After the image builds run `docker compose up`

Note that this environment can be used in conjunction with an existing project; however, FrankenPHP's minimum PHP version is 8.2 which won't be compatible with most projects.

## Ports
The default host ports applied in the committed `.env` are:
- Application (http) on `3030` and https on `4040` (in other words, `localhost:3000` and `localhost:4000`)
- `9025` for email
- `44000` for the databases
- `42000` for Redis.
These can be changed in `docker/.env` to suite the needs of the developer.

## OS Context
The default, non-root user in the container is `chill` and the work directory is their home directory. Entering the container with: `docker exec -it <YOUR_APP_CONTAINER_NAME_HERE>` will pop you into the shell as the `chill` user.

## Databases
Two databases get created during the build step: `chill_dev` and `chill_test`. See `docker/.build/postgres/create-databases.sql` for respective credentials. The `POSTGRES_PASSWORD` in `.env` refers to the default `postgres` user in the database.
