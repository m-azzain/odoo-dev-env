# About This Repo
It is a repository to create development enviroment for odoo using docker compose. It has been inspired by odoo docker image [odoo docker](https://github.com/odoo/docker)


**What You need it for?**

- If you are [docker compose](https://docs.docker.com/compose/) enthusiast and want to do development with odoo.
- Or you may face difficulties in setting up your development enviroment, so you may resort to use docker.


**How to use it**
*These instructions assuming that you are using linux machine*

- [Install docker compose](https://docs.docker.com/compose/install/) into your machine.
- make a common directory to include this repo and [odoo](https://github.com/odoo/odoo.git), let us call it common.
    ``` 
    mkdir ~/common 
    cd ~/common
    ```
- clone this repository and [odoo](https://github.com/odoo/odoo.git) inside the common directory.
    ```
    git clone https://github.com/odoo/odoo.git
    git clone https://github.com/m-azzain/odoo-dev-env.git
    ```
- copy the .dockerignore file to the common directory
    ```
    cd odoo-dev-env
    cp ./.dockerignore ../
    ```
- run `sudo docker compose up`
- If every thing went well you can access the running server on `localhost:8069`
- For more docker compose commands you can visit their site [docker compose docs](https://docs.docker.com/compose/).

