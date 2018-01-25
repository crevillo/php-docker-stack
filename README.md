# php-docker-stack

Docker stack es un repositorio destinado a la generación de ficheros de docker compose
para nuestros proyectos en The Cocktail.   

## instalación
Clona este repositorio en tu disco. 

## Úsalo
Para generar un `docker-compose.yml` dirígite a la carpeta donde hayas clonado este repositorio
y ejecuta `./stack.sh build`. El script te preguntará qué cosas llevará tu proyecto y
generará el fichero en función de tus respuestas. 

# Addons
A la hora de montar tu entorno el sistema te preguntará si quieres añadir más funcionalidades. De momento te preguntará
si quieres añadir las siguientes opciones

* memcache
* redis
* mailcatcher
* phpmyadmin

Podrás elegir sí o no a cada una de ellas. 


