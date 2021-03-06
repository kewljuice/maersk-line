# MAERSK LINE

- [Docker](#docker)
- [Installation](#installation)
- [Browse](#browse)
- [Components](#components)
- [Uninstall](#uninstall)

## Docker

Install docker for mac via the latest stable installation from [docs.docker.com](https://docs.docker.com/docker-for-mac/)

## Installation

- You can directly clone to your directory using<br>
```$ git clone -b 1.0 --depth 1  https://github.com/kewljuice/maersk-line```
- Browse to maersk-line folder in terminal
- Check docker status
```bash docker-status.sh```
- Restart docker containers
```bash docker-restart.sh```
- Remove docker container and images
```bash docker-cleanup.sh```
- Init website
```bash website-install.sh```
- Remove website
```bash website-remove.sh```
- Update CiviCRM
```docker-compose run --rm build bash /var/www/civicrm-update.sh```

## Containers

- NGiNX
- PHP
- Drupal
- CIVIX
- MySQL
- phpMyAdmin

## Browse

* application: open browser and go to [localhost:8080](http://localhost:8080)
  * administrator login: (admin/admin)
  * moderator login: (moderator/moderator)
* phpyadmin: open browser and go to [localhost:8181](http://localhost:8181)
  * root login: (root/root)
  
## Components

* Git Init/Branches
* Drupal Installation/Configuration/3th party modules & themes
* CiviCRM version 4.7.16

## Uninstall

* Complete docker containers & images (careful!!!)
  * Browse to maersk-line folder in terminal
  * Cleanup images and containers 
  ```bash docker-cleanup.sh```
* Drupal/CiviCRM installation in container
  * Go to Drupal container 
  ```docker exec -it docker_drupal_X sh bash```
  * Go to /var/www/ folder 
  ```cd /var/www```
  * Execute cleanup script
  ```bash cleanup.sh```
  
