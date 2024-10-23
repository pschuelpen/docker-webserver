# Docker Webserver

This image will allow you to run any Webservice including a Database within one container so that you are able to Test small applications as if they run on a single Device e.g RaspberryPi. Anyway you can also just run your applications within this container and keep everything nice and clean.

## How to use

### 1. Clone the Git Repository

```shell
https://gitlab.com/pschuelpengroup/docker-webserver.git
```

### 2. Build the Image

```shell
docker build -t dck_webserver_img ./
```

### 3. Run the Image with a webpage of your choice

for example:
```shell
sudo docker run -d \
    -p <someport>:80 \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=name \
    -e DB_USER_NAME=username \
    -e DB_USER_PASSWORD=password \
    -e DB_INIT_METHOD=1 \
    -e DB_INIT_SCRIPT_PATH=/path/to/script.sql
    --name=webseite_name \
    --restart=unless-stopped \
    -v path/to/website:/var/www/html \
    dck_webserver_img
```

## Options

Of course as you can see above there are some ways to modify how the Webserver is initialized. But first some info about the obvious Options:

1. Select a Port that is free on your host replace `<someport>`
2. Set `MYSQL_ROOT_PASSWORD` and `MYSQL_DATABASE` Name. Of course make sure that this name is represented by your website service
3. Set `DB_USER_NAME` and `DB_USER_PASSWORD`
4. Set your Container Name and mount the Volume Path to your website that you'd like to use

Now the variable options:

### Mode 1

This Mode is quiet simple as it enables you to start the service with a single sql Script. If you only require one Script you should use this approach

Using this mode you only need to specify the `DB_INIT_METHOD=1` and can continue by setting the `DB_INIT_SCRIPT_PATH=/path/to/script.sql` to the location of your Script


### Mode 2 

This Mode is more "advanced" and enables you to specify a location where a set of scripts lay around that will all be initialized into the Database. For instance if you have a main Script and a lot of updating Scripts that elevate your Database version step by step you can do so with `mode 2` like this:

```shell
sudo docker run -d \
    -p <someport>:80 \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=name \
    -e DB_USER_NAME=username \
    -e DB_USER_PASSWORD=password \
    -e DB_INIT_METHOD=2 \
    -e DB_INIT_PATH=path/to/sql_folder \
    --name=webseite_name \
    --restart=unless-stopped \
    -v path/to/website:/var/www/html \
    dck_webserver_img
```

Options in here are quiet similiar therefore you only need to change the obvious parameters

## Additionally - Safety Information
 
Do not deploy this container in a potentially dangerous enviroment since I think doing it that way may be bad practice. Normally you would deploy both in their own respective containers.

Anyway be aware of the risk and use it on your safe development enviroment.

I hope you can work with this!

Have fun!!