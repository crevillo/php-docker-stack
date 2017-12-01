#!/usr/bin/env bash

DOCKER_COMPOSE=${DOCKER_COMPOSE:=docker-compose}

DOCKER_COMPOSE_FILE=${COMPOSE_FILE:=docker-compose.yml}

DOCKER_COMPOSE_CONFIG_FILE=${DOCKER_COMPOSE_CONFIG_FILE:=docker-compose.config.sh}

MYSQL_VERSION=5.7

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

# copy template yml file to final docker-compose-template.yml file
buildDockerComposeFile() {

   template_file="docker-compose-template.yml"

   echo "Generando composer file ..."
   cp "$template_file" "$DOCKER_COMPOSE_FILE"

   configureMysql

}

configureMysql() {
    mysql_version=0
    while [ $mysql_version = 0 ]
    do
        options=($(ls images/mysql))
        options_imploded=''
        nversions=${#options[@]}
        for version in "${!options[@]}"
        do
            version_name=${options[$version]}
            if [ $version_name = $MYSQL_VERSION ]; then
                version_name=($(echo $version_name | sed -e 's/^/\[/'))
                version_name=($(echo $version_name | sed -e 's/$/\]/'))
            fi
            options_imploded=${options_imploded}${version_name}
            if [ $version -lt $((nversions-1)) ]; then
                options_imploded=${options_imploded}", "
            fi
        done

        read -p "[?] ¿Qué mysql necesitas? $options_imploded: " mysql_version
        mysql_version=${mysql_version:-$MYSQL_VERSION}
        echo $mysql_version
        if [ ! -d "images/mysql/$mysql_version" ]; then
            echo "No tenemos esa imagen"
            mysql_version=0
        fi
    done



    mysql_template=$( cat templates/mysql.yml )
    mysql_service=${mysql_template/\#\#MYSQL_VERSION\#\#/$mysql_version}
    echo "$mysql_service" >> $DOCKER_COMPOSE_FILE
}


chooseProject() {
    echo "Generando fichero de configuración ...";

    options=($(ls projects))
    PS3="[?] ¿Con qué proyecto necesitas trabajar? "
    nprojects=${#options[@]}
    select opt in "${options[@]}"; do

        case "$REPLY" in

        [1-$nprojects] ) PROJECT_NAME=$opt; break;;
        *) echo "Invalid option. Try another one.";continue;;

        esac
    done
}

selectAddOns() {
    addons=($(ls addons))
    for addon in "${addons[@]}"
    do
        addon=${addon/.yml/}
        read -p "¿Quieres añadir $addon? [s/n]" -n 1 -r
        echo    # (optional) move to a new line
        if [[ $REPLY =~ ^[Ss]$ ]]
        then
            cat addons/$addon.yml >> $DOCKER_COMPOSE_FILE
        fi
    done
}

chooseProject

if [ ! -d images/back/tmp ]; then
    mkdir images/back/tmp
fi

cp projects/$PROJECT_NAME/back/init.sh images/back/tmp/init.sh

if [ -f "projects/$PROJECT_NAME/db/db.sql.gz" ]; then
   cp projects/$PROJECT_NAME/db/db.sql.gz images/back/tmp/db.sql.gz
fi

source projects/$PROJECT_NAME/docker.env.local

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
        if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
        buildDockerComposeFile
        selectAddOns
        fi
        cloneFromGithubIfNeeded
        $DOCKER_COMPOSE -p "$PROJECT" stop
        $DOCKER_COMPOSE -p "$PROJECT" up
        rm -rf images/back/tmp
    ;;

    rebuild)
        $DOCKER_COMPOSE -p "$PROJECT" down
        if [ -f "docker-compose.yml" ]; then
            rm docker-compose.yml
        fi
        buildDockerComposeFile
        selectAddOns
        cloneFromGithubIfNeeded
        $DOCKER_COMPOSE -p "$PROJECT" up --build
        rm -rf images/back/tmp
    ;;
    stop)
        $DOCKER_COMPOSE -p "$PROJECT" down
    ;;
esac

