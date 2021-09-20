How to Deploy a **Django** Application with **DockerFile** and **Docker Compose** ?
Here we will discuss about both the approach .
Docker Dock link : https://docs.docker.com/samples/

Lets just play with _**Dockerfile**_ :
step 1 -> create django project from documentation and develop it 
ref : https://docs.djangoproject.com/en/3.2/
 
step 2 ->
in the main project directory we will store our virtual environment packages in requirements.txt
use command : pip freeze > requirements.txt
  
step 3 ->
create a Dockerfile 
use command : echo > Dockerfile

step 4 -> 
edit this Dockerfile with these lines **(DO NOT COPY FROM HERE IT WILL FAIL WHILE BUILD COPY FROM Dockerfile FILE)**

WORKDIR /code  # defining working directory of the container
COPY requirements.txt /code/     # copying required packages in that folder to make work the application 
RUN pip install -r requirements.txt   #installing them
COPY . /code/  # Copy the whole directory for storing the source code after development

EXPOSE 8000 # we want to expose 8000 port to outside world
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]  # command will start the server

step-> 5
build the docker image
use command : docker build -t dockerpractice . #this will create an image named dockerpractice from current directory

you will look like this after hitting this command :
(venv) H:\devops\Docker-practice-with-django\demo_project>docker build -t dockerpractice .
[+] Building 4.1s (11/11) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                               0.2s
 => => transferring dockerfile: 246B                                                                                                                                               0.1s
 => [internal] load .dockerignore                                                                                                                                                  0.1s
 => => transferring context: 2B                                                                                                                                                    0.0s
 => [internal] load metadata for docker.io/library/python:3                                                                                                                        3.2s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                                      0.0s
 => [1/5] FROM docker.io/library/python:3@sha256:e6654afa815122b13242fc9ff513e2d14b00548ba6eaf4d3b03f2f261d85272d                                                                  0.1s
 => => resolve docker.io/library/python:3@sha256:e6654afa815122b13242fc9ff513e2d14b00548ba6eaf4d3b03f2f261d85272d                                                                  0.1s
 => [internal] load build context                                                                                                                                                  0.1s
 => => transferring context: 1.73kB                                                                                                                                                0.0s
 => CACHED [2/5] WORKDIR /code                                                                                                                                                     0.0s
 => CACHED [3/5] COPY requirements.txt /code/                                                                                                                                      0.0s
 => CACHED [4/5] RUN pip install -r requirements.txt                                                                                                                               0.0s
 => [5/5] COPY . /code/                                                                                                                                                            0.1s
 => exporting to image                                                                                                                                                             0.2s
 => => exporting layers                                                                                                                                                            0.1s
 => => writing image sha256:cb2e11477ff5ce3cd024b13d2bad1b0db2d0993547ab296d9bcfce2c4c2355a7                                                                                       0.0s
 => => naming to docker.io/library/dockerpractice                                                                                                                                  0.0s


step 6 ->
lets see if the image has been created or not
use command : docker images

you will look like this after hitting this command :
C:\Users\Suvam>docker images
REPOSITORY                           TAG                                                     IMAGE ID       CREATED          SIZE
dockerpractice                       latest                                                  cb2e11477ff5   2 minutes ago    957MB

step 7 ->
Finally Its time to run our container and start the service

use command : docker run -it --name=dockerpractice -p 8000:8000 dockerpractice
we are instructing to make a container from dockerpractice image that will start our application in 8000 port in the docker machine and expose it in 8000
to the outside world

you will look like this after hitting this command :

(venv) H:\devops\Docker-practice-with-django\demo_project>docker run -it --name=dockerpractice -p 8000:8000 dockerpractice
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

September 20, 2021 - 12:22:22
Django version 3.2.7, using settings 'demo_project.settings'
Starting development server at http://0.0.0.0:8000/


step 8 -> 
lets open your browser and hit http://127.0.0.1:8000/
you will see your containerised application

lets check our container and down the service
C:\Users\Suvam>docker container ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                       NAMES
0057d30526c7   dockerpractice   "python manage.py ru…"   6 minutes ago   Up 6 minutes   0.0.0.0:8000->8000/tcp, :::8000->8000/tcp   dockerpractice

C:\Users\Suvam>docker container rm -f 0057d30526c7 # removing the container
0057d30526c7

**_Docker-Copmpose_**
Now we will talk about docker compose where we will handle multiple services with different containers . In case we are working with micro-services that have many services
and need to maintain hardly  multiple containers , this is very helpful .

suppose we have an e-commerce application ,  where  we have four services web-application,database,professional email and some session layer(Redis) .
Now it is hectic to write different dockerfile and maintain them . To avoid this we use docker-compose to available these services from a single docker instruction file and it has some
special feature like mentioning dependency of a service , certain ports configuration and volumes that holds data even the container is down.

_lets do it practically_ : 

in the previous steps we will change from step 3 to achieve this .

step 3 ->
create a docker-compose.yaml 
use command : echo > docker-compose.yaml 

step 4 ->
edit the docker-compose.yaml (**DO NOT COPY FROM HERE IT WILL FAIL WHILE BUILD COPY FROM docker-compose.yaml FILE** )


version: '3.9'

services:
  web:
    restart: always   # alwayas restart this service 
    build: .  #instructing to build the current folder
    ports:
      - "8000:8000"  # first port is the exposed to outside world  (8000) and last port (8000) is the target port of container
    links:
      - postgres:postgres  #this web service depends upon with postgress database to store data
      - redis:redis    #this web service is linked with redis to catch session data as per code
    volumes:
      - web-django:/usr/src/app  #after shutting down this container this folder will remain as it is a volume
      - web-static:/usr/src/app/static  #after shutting down this container this folder will remain as it is a volume
    env_file: .env  #we do have some env file configuration 
    environment:
      DEBUG: 'false'
    command: bash -c "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"  # before starting the server it will migrate the changes in database and up the service 

  

  postgres:
    restart: always
    image: postgres:latest  # for postgress sql we will download the image from dockerhub
    ports:
      - "5432:5432"  # first port is the exposed to outside world  (5432) and last port (5432) is the target port of container
    volumes:
      - pgdata:/var/lib/postgresql/data/  #after shutting down this container this data will remain as it is a volume

  redis:
    restart: always
    image: redis:latest # for redis  we will download the image from dockerhub
    ports:
      - "6379:6379"  # first port is the exposed to outside world  (6379) and last port (6379) is the target port of container
    volumes:
      - redisdata:/data  #after shutting down this container this data will remain as it is a volume

volumes:
  web-django:
  web-static:
  pgdata:
  redisdata:


