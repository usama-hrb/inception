*This project has been created as part of the 42 curriculum by oelharbi.*

# Inception

## Description

Inception is a system administration project. The goal is to build a small
web infrastructure using Docker, with each service running in its own
container.

The project sets up three containers:

- **NGINX** — the only entry point to the infrastructure. It serves the
  website over HTTPS (TLSv1.2 / TLSv1.3 only) on port 443.
- **WordPress + php-fpm** — runs the WordPress site, without any web server
  bundled in. NGINX talks to it over port 9000.
- **MariaDB** — the database used by WordPress.

Each container is built from its own `Dockerfile`, starting from a Debian
base image. No pre-built images are pulled from Docker Hub, and no image
uses the `latest` tag. All containers are connected through one dedicated
Docker network, and they restart automatically if they crash.

Two named volumes keep data across restarts:

- one for the WordPress database (used by MariaDB)
- one for the WordPress files (shared between WordPress and NGINX)

All configuration files live in the `srcs` folder, and the whole stack is
built and started through the `Makefile` at the root of the repository,
which calls `docker compose`.

### Design choices

**Virtual Machine vs Docker**
A virtual machine emulates a full computer, including its own kernel, which
makes it heavy and slow to start. Docker containers share the host kernel
and only package the application and its dependencies, so they start in
seconds and use far less memory. This project only needs isolated services,
not full operating systems, so Docker is the better fit.

**Secrets vs Environment Variables**
Environment variables are simple and are used here for non-sensitive
settings (like the domain name or database names) through a `.env` file.
Docker secrets go a step further for real sensitive data such as passwords:
they are mounted as files inside the container at runtime instead of being
stored in the container's environment or in its image layers, which lowers
the risk of a password leaking through `docker inspect` or process listings.

**Docker Network vs Host Network**
Using the host network would put containers directly on the host's network
stack, with no isolation and a higher risk of port conflicts. A dedicated
Docker network keeps the containers isolated from the host and from other
projects, while still letting them reach each other by service name. Only
NGINX exposes a port to the outside world (443), which matches the rule that
it must be the single entry point into the infrastructure.

**Docker Volumes vs Bind Mounts**
A bind mount points directly to a folder on the host and depends on that
exact path existing with the right permissions, which is fragile and harder
to manage. A named Docker volume is managed by Docker itself, works the same
way regardless of the host setup, and is easier to back up, inspect, or
move between containers. That is why this project uses named volumes for
the database and the WordPress files.

## Instructions

### Requirements

- A Linux virtual machine with Docker and Docker Compose installed
- `make`
- Root/sudo access (the Makefile cleans up files under `/home/<login>/data`)

### Setup

1. Add your domain name to `/etc/hosts` on the host so it points to your
   local machine, for example:
   ```
   127.0.0.1  oelharbi.42.fr
   ```
2. Fill in the `.env` file inside `srcs/` with your own values (database
   name, users, passwords, domain name, WordPress admin info). Never commit
   real credentials to Git.

### Build and run

From the root of the repository:

```sh
make up      # builds the images and starts all containers
```

Once the containers are up, open `https://<your-domain>` in a browser to
reach the WordPress site (accept the self-signed certificate warning, since
this is a local development certificate).

### Stop and clean

```sh
make down    # stops and removes the containers and their volumes
make fclean  # stops everything and removes images, volumes and local data
make re      # fclean then up, for a full rebuild
```

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [OpenSSL documentation](https://docs.openssl.org/)

AI assistance was used while working on this project to help understand
Docker and service configuration concepts, to get a second opinion on
Dockerfile and `docker-compose.yml` structure, and to draft this README.
Every suggestion was reviewed, tested, and adapted before being used, and
all final configuration choices and explanations above reflect my own
understanding of the project.
