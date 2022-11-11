## Linux Nginx PostgreSQL PHP (LNPP) Stack

This repo contains a Dockerfile that creates a custom Docker PHP 8.1 image that is built alongside the other services listed in `docker-compose.yaml` to create an LNPP stack. To use, copy the `docker` directory to a given project's directory and fill in the app name and host ports in `docker/.env`.

### Environment build steps
- While in this directory, run `docker compose build`
- After the image builds run `docker compose up`

### Env notes
Devs can change the host ports in .env to allow flexibility in running other services outside of these Docker containers. Note that these containers are not set-up with Traefik so you may encounter issues if you set `HOST_APP_PORT` and `HOST_SECURE_APP_PORT` to 80 and 443 respectively.

### Container notes
The non-root user in the container is `zing` and the work directory is set as `/var/www/html/app`.

### Database notes
Two databases get created during the build step: `local_dev` and `local_test` which enables having separate databases between the dev and test environments. Credentials for those respective databases can be found in `docker/postgres/init/01-create-databases.sql`
