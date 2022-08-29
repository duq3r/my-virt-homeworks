
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"


---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

## Ответ <br>
https://hub.docker.com/repository/docker/duq3r/my-webserver

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
  <Br>-В этом случае больше бы подошла виртуальная машина или железный сервер.
- Nodejs веб-приложение;
<br>-Docker подходит. Т.к. всё можно реализовать на контейнерах.
- Мобильное приложение c версиями для Android и iOS;
  <br>-Сборка Андройд и деплой Андройд приложений возможен в Docker. На iOs нет. 
- Шина данных на базе Apache Kafkа
   <br>-Docker подходит. Т.к. всё можно реализовать на контейнерах. 
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
  <br>-Docker подходит. Т.к. всё можно реализовать на контейнерах.
- Мониторинг-стек на базе Prometheus и Grafana;
  <br>Docker подходит. Т.к. всё можно реализовать на контейнерах.
- MongoDB, как основное хранилище данных для java-приложения;
   <br>-Docker не подходит для хранения. Т.к. контейнеры не могут служить сущностью для хранения данных. Но можно подключить Volume на хосте и тогда база будет изменяемой и доступной при перезапуске контейнера с базой.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
   <br>-Думаю, Docker не подходит. Для этого нужны отдельные виртуальные сервера.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Ответ <br>
```text/x-sh

vagrant@server1:~/data$ ls
111.test
vagrant@server1:~/data$ docker run -it --rm -d -v /home/vagrant/data:/data --name centos centos
c7134aa4a43842f07fae7c93a2e4157d62a7112bc437d3936b37ef96012b3f90
vagrant@server1:~/data$ docker run -it --rm -d -v /home/vagrant/data:/data --name debian debian
dd98beedce7249b326e259db5058ae7e013607170f13add1eb2c5f4050b4325a
vagrant@server1:~/data$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                NAMES
dd98beedce72   debian         "bash"                   3 seconds ago    Up 2 seconds                         debian
c7134aa4a438   centos         "/bin/bash"              12 seconds ago   Up 11 seconds                        centos
6d6c4dfd25bf   my-webserver   "/docker-entrypoint.…"   5 hours ago      Up 5 hours      0.0.0.0:80->80/tcp   my-web
vagrant@server1:~/data$ docker exec -it centos /bin/bash
[root@c7134aa4a438 /]# cd /data
[root@c7134aa4a438 data]# ls
111.test
[root@c7134aa4a438 data]# vi 222.test
[root@c7134aa4a438 data]# exit
exit
vagrant@server1:~/data$ docker exec -it debian /bin/bash
root@dd98beedce72:/# cd /data
root@dd98beedce72:/data# ls
111.test  222.test
root@dd98beedce72:/data# exit
exit
vagrant@server1:~/data$ ls
111.test  222.test
vagrant@server1:~/data$ nano
vagrant@server1:~/data$ nano 333.test
vagrant@server1:~/data$ docker exec -it debian /bin/bash
root@dd98beedce72:/# cd /data
root@dd98beedce72:/data# ls
111.test  222.test  333.test
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

## Ответ <br>
https://hub.docker.com/repository/docker/duq3r/ansible
---



---