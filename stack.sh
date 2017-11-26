#!/usr/bin/env bash

if [ -f "docker-compose.yml" ]; then
    rm docker-compose.yml
fi

DOCKER_COMPOSE=${DOCKER_COMPOSE:=docker-compose}

DOCKER_COMPOSE_FILE=${COMPOSE_FILE:=docker-compose.yml}

DOCKER_COMPOSE_CONFIG_FILE=${DOCKER_COMPOSE_CONFIG_FILE:=docker-compose.config.sh}

COMPOSE_ENV=all

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

# copy template yml file to final docker-compose-template-all.yml file
buildDockerComposeFile() {
    if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then

        #choose which template should be used for project

        #docker_compose_template_type=${docker_compose_template_type:-nginx}
        template_file="docker-compose-template-$COMPOSE_ENV.yml"

        #if [ ! -f "$template_file" ]; then
        #    echo "ERROR: wrong template file specified. Aborting ..."
        #    exit 1;
        #fi

        echo "Generando composer file ..."
        echo $template_file
        cp "$template_file" "$DOCKER_COMPOSE_FILE"
    fi
}


chooseProject() {
    echo "Generando fichero de configuración ...";

    options=($(ls projects))
    PS3="[?] ¿Con qué proyecto necesitas trabajar? "
    select opt in "${options[@]}"; do

        case "$REPLY" in

        [1-2] ) PROJECT_NAME=$opt; break;;
        *) echo "Invalid option. Try another one.";continue;;

        esac
ln -s -f
    done

    PS3="[?] ¿Qué entorno(s) quieres levantar? "
    envs=("dev" "pro" "all")
    select opt in "${envs[@]}"; do

        case "$REPLY" in

        [1-2] ) COMPOSE_ENV=$opt; break;;
        3 ) COMPOSE_ENV=$opt; break;;
        *) echo "Invalid option. Try another one.";continue;;

        esac
ln -s -f
    done
}


chooseProject

mkdir images/back/tmp
cp projects/$PROJECT_NAME/back/init.sh images/back/tmp/init.sh

source projects/$PROJECT_NAME/docker.env.local
buildDockerComposeFile



cloneFromGithubIfNeeded() {
    if [ ! -d "$PROJECT" ]; then
        if [ ! -z "$GITHUB_TAG" ]; then
            git clone --branch $GITHUB_TAG $GITHUB_REPO $PROJECT
        else
            git clone $GITHUB_REPO $PROJECT
        fi
    fi
}

case "$1" in
    start|run)
        cloneFromGithubIfNeeded
        $DOCKER_COMPOSE -p "$PROJECT" stop
        $DOCKER_COMPOSE -p "$PROJECT" up
        rm -rf images/back/tmp
    ;;

    build)
        echo "${red}!Cuidado! Con esto perderás todo lo que tengas en las bases de datos.${end}"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) $DOCKER_COMPOSE -p "$PROJECT" up --build; break;;
                No ) exit;;
            esac
        done

        rm -rf images/back/tmp

    ;;
    stop)
        $DOCKER_COMPOSE -p "$PROJECT" down
    ;;
esac

