# php-docker-stack

Docker start para trabajar con proyectos php. El stack trata de simular
los entornos de producción de nuestra empresa y además proporciona un 
entorno de desarrollo. Se ha realizado el primer experimiento partiendo
de una instalación de eZ Platform. 

## instalación
Clona este repositorio en tu disco. 

## Úsalo
Para arrancar tu entorno dirígite a la carpeta donde hayas clonado este repositorio
y ejecuta `./stack.sh start`. El script te dara a elegir los proyectos
con los que puedes trabajar. 

## Imágenes
Actualmente, el sistema monta las siguientes imágenes

| image  | tipo  | entornos  |
|---|---|---|
| front1 | nginx   | pro   |
| back1  | php-fpm1  | pro  |
| varnish  | varnish  | pro  |
