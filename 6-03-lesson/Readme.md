# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Ответ <br>
~~~
#Docker-compose.yaml
version: '3.3'
services:
  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: 'test_db'
      MYSQL_ROOT_PASSWORD: 'mysql'
    ports:
      # <Port exposed> : < MySQL Port running inside container>
      - '3306:3306'
    expose:
      # Открываем 3306 порт на контейнере
      - '3306'
      # volume, где будут храниться данные
    volumes:
      - vol_mysql:/etc/mysql
# Имя нашего vulume
volumes:
  vol_mysql:

Запускаю Docker-compose:
$ > docker-compose up -d
Starting 6-03-lesson_db_1 ... done
10:54:15 vagrant@server1:[/vagrant/6-03-lesson(main)]:
$ > docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                               NAMES
b2aa84dd85df   mysql:8.0   "docker-entrypoint.s…"   4 minutes ago   Up 8 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp   6-03-lesson_db_1
~~~
```
Запускаю консольный mysql в контейнере:
06:16:53 vagrant@server1:[/vagrant/6-03-lesson(main)]:
$ > docker exec -it 6-03-lesson_db_1 mysql -p
Enter password:
.....
mysql>

```
Статус БД:
```
mysql> \s
--------------
mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          12
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.30 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 4 min 21 sec

Threads: 2  Questions: 48  Slow queries: 0  Opens: 176  Flush tables: 3  Open tables: 95  Queries per second avg: 0.183
--------------

mysql> 
```
Импорт дампа выполнил в DBeaver. Предварительно выполнив 
mysql> CREATE DATABASE test_db
```
id|title                |price|
--+---------------------+-----+
 1|War and Peace        |  100|
 2|My little pony       |  500|
 3|Adventure mysql times|  300|
 4|Server gravity falls |  300|
 5|Log gossips          |  123|
```

Вывод числа позиций дороже 300.
~~~
mysql> use test_db;
Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

mysql>
~~~


## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Ответ <br>
~~~

mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
Query OK, 0 rows affected (0.05 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.02 sec)

mysql> alter user 'test'@'localhost'
    -> identified by 'test-pass'
    -> with
    -> max_queries_per_hour 100
    -> password expire interval 180 day
    -> failed_login_attempts 3 password_lock_time 2;
Query OK, 0 rows affected (0.03 sec)

mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql>

~~~


## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Ответ <br>
~~~

mysql> SET @@profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.06 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.06591550 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.11047100 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)

mysql>
~~~
Переключение на движок MyISAM = 0.06 секунд. <br>
Переключение на движок InnoDB = 0.11 секунд.
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

## Ответ <br>

~~~
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

#Set IO Speed
# 0 - скорость
# 1 - сохранность
# 2 - что-то среднее
innodb_flush_log_at_trx_commit = 0 

#Set buffer
innodb_log_buffer_size	= 1M

#Set Cache size
key_buffer_size = 640М

#Set log size
max_binlog_size	= 100M

# Наш конфиг надо класть по этому пути
!includedir /etc/mysql/conf.d/
~~~

---



---
