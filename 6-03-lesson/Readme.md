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
```
02:41:49 vagrant@server1:[~/.ssh]:
$ > docker pull mysql:8.0
8.0: Pulling from library/mysql
Digest: sha256:b9532b1edea72b6cee12d9f5a78547bd3812ea5db842566e17f8b33291ed2921
Status: Downloaded newer image for mysql:8.0
docker.io/library/mysql:8.0
02:42:54 vagrant@server1:[~/.ssh]:
$ > docker volume create vol_mysql
vol_mysql
02:43:34 vagrant@server1:[~/.ssh]:
$ > docker run --rm --name mysql-docker -e MYSQL_ROOT_PASSWORD=mysql -d -p 3306:3306 -v vol_mysql:/etc/mysql/ mysql:8.0
08:06:03 vagrant@server1:[~]:
$ > docker exec -it mysql-docker bash
bash-4.4# mysql -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.30 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

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
mysql> CREATE DATABASE test_

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
# 2 - универсальный параметр
innodb_flush_log_at_trx_commit = 0 

#Set compression
# Barracuda - формат файла с сжатием
innodb_file_format=Barracuda

#Set buffer
innodb_log_buffer_size	= 1M

#Set Cache size
key_buffer_size = 640М

#Set log size
max_binlog_size	= 100M
~~~

---



---
