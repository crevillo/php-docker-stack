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
con los que puedes trabajar. La primera ejecución llevará su tiempo pues 
tendrá que ejecutar todos los procesos de instalación de esas máquinas. 
También te preguntará si sólo quieres montar un entorno para desarrollar (menos cachés), un entorno para simular 
pro o ambos. 

## Imágenes
Actualmente, el sistema monta las siguientes imágenes, las cuáles se usan
dependiendo del entorno usado.

Nota: Estamos pensando en Symfony a la hora de hablar de entornos, quizás habrá que 
tener en cuenta otros frameworks...

| image  | tipo  | entornos  |
|---|---|---|
| front1 | nginx   | pro   |
| back1  | php-fpm 7.1  | pro  |
| varnish  | varnish  | pro  |
| mysql | mysql:5.7 | dev,pro |
| front_dev_1 | nginx | dev |
| back_dev_1 | nginx | dev |

# Addons
A la hora de montar tu entorno el sistema te preguntará si quieres añadir más funcionalidades. De momento te preguntará
si quieres añadir las siguientes opciones

* memcache
* redis
* mailcatcher
* phpmyadmin

Podrás elegir sí o no a cada una de ellas. 


## Configuración

Para poder usar un proyecto, tiene que estar definido en este repositorio. Para ello hay que crear una
carpeta con su nombre dentro de `projects`.

Dentro de cada carpeta de proyecto tendremos los siguientes archivos
* docker.env.local -> define las variables que usaremos en el proceso de inicio del docker, para asingar puertos principalmente
* vars.env -> variables de entorno para ser usadas en entorno de producción. en el caso de ez lo definimos como entorno de docker, aunque
no es más que una copia del entorno pro
* vars.dev.env -> variables de entorno dev. 

Además, habrá una serie de carpetas en la que se podrán configurar cada una de las imágenes

### back

la idea es que tengamos un archivo `init.sh` que ejecutaremos siempre que inciemos esta imagen. casos de uso
típicos pueden ser el composer install o el crear las bases de datos si así lo necesitamos. cada proyecto
puede proveer el suyo

### db
Por confirmar cómo hacemos esto. Quizás podríamos usarla para usar dumps de versiones en producción y trabajar con ellas...

### dev
En principio aquí solo necesitaremos el vhost que vamos a utilizar en el entorno de dev. la particularidad es que debemos
decirle que el fpm está en la máquina `back_dev`

### nginx
Vhosts necesarios para el nginx en producción. Por ejemplo, configuración del proxy con varnish, o el site en sí. 

### varnish
vcl a usar con varnish.

## Para desarrollar. 
Contarás con dos entornos. el entorno dev será accesible en una dirección del tipo http://localhost:[port]. El port 
lo podrás definir en el fichero docker.env.local de tu proyecto. De igual forma, para trabajar en modo  prod, tendrás
una dirección similar. El puerto vendrá dado por el valor que le des a `HAPROXY_PORT`.

El entorno de dev no trabajará contra varnish. el de prod sí. De igual forma, en el entorno prod tus peticiones irán
contra un haproxy con ssl, para así poder simular lo que tenemos en nuestros entornos de pro. 

