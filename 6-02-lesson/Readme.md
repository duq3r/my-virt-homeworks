# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

## Ответ <br>

~~~
docker pull postgres:12
docker volume create vol2
docker volume create vol1
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v vol1:/var/lib/postgresql/data -v vol2:/var/lib/postgresql postgres:12
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v vol1:/var/lib/postgresql/data -v vol2:/var/lib/postgresql postgres:12
~~~

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

## Ответ <br>
~~~
CREATE DATABASE test_db

CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;

CREATE TABLE orders 
(
id integer, 
name text, 
price integer, 
PRIMARY KEY (id) 
);

CREATE TABLE clients 
(
	id integer PRIMARY KEY,
	lastname text,
	country text,
	booking integer,
	FOREIGN KEY (booking) REFERENCES orders (Id)
);

CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
GRANT SELECT ON TABLE public.clients TO "test-simple-user";
GRANT INSERT ON TABLE public.clients TO "test-simple-user";
GRANT UPDATE ON TABLE public.clients TO "test-simple-user";
GRANT DELETE ON TABLE public.clients TO "test-simple-user";
GRANT SELECT ON TABLE public.orders TO "test-simple-user";
GRANT INSERT ON TABLE public.orders TO "test-simple-user";
GRANT UPDATE ON TABLE public.orders TO "test-simple-user";
GRANT DELETE ON TABLE public.orders TO "test-simple-user";
~~~
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db<br>
 select * from information_schema.table_privileges where grantee in ('test-admin-user','test-simple-user')
~~~
grantor |grantee         |table_catalog|table_schema|table_name|privilege_type|is_grantable|with_hierarchy|
--------+----------------+-------------+------------+----------+--------------+------------+--------------+
postgres|test-simple-user|test_db      |public      |clients   |INSERT        |NO          |NO            |
postgres|test-simple-user|test_db      |public      |clients   |SELECT        |NO          |YES           |
postgres|test-simple-user|test_db      |public      |clients   |UPDATE        |NO          |NO            |
postgres|test-simple-user|test_db      |public      |clients   |DELETE        |NO          |NO            |
postgres|test-simple-user|test_db      |public      |orders    |INSERT        |NO          |NO            |
postgres|test-simple-user|test_db      |public      |orders    |SELECT        |NO          |YES           |
postgres|test-simple-user|test_db      |public      |orders    |UPDATE        |NO          |NO            |
postgres|test-simple-user|test_db      |public      |orders    |DELETE        |NO          |NO            |
~~~
- итоговый список БД после выполнения пунктов выше,
~~~
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
~~~

-Описание таблиц
~~~
postgres=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}

postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)


~~~

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

~~~
insert into orders VALUES 	(1, 'Шоколад', 10), 
						(2, 'Принтер', 3000), 
						(3, 'Книга', 500), 
						(4, 'Монитор', 7000), 
						(5, 'Гитара', 4000);
~~~
Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

~~~
insert into clients VALUES (1, 'Иванов Иван Иванович', 'USA'), 
						   (2, 'Петров Петр Петрович', 'Canada'), 
						   (3, 'Иоганн Себастьян Бах', 'Japan'), 
						   (4, 'Ронни Джеймс Дио', 'Russia'), 
                           (5, 'Ritchie Blackmore', 'Russia');
~~~

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
~~~
select count (*) from orders; 
count|
-----+
    5|

select count (*) from clients; 
count|
-----+
    5|
~~~


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
~~~
update  clients set booking = 3 where id = 1;
update  clients set booking = 4 where id = 2;
update  clients set booking = 5 where id = 3;
~~~
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 ~~~
 select * from clients as c where  exists (select id from orders as o where c.booking = o.id) ;

 id|lastname            |country|booking|
--+--------------------+-------+-------+
 1|Иванов Иван Иванович|USA    |      3|
 2|Петров Петр Петрович|Canada |      4|
 3|Иоганн Себастьян Бах|Japan  |      5|
 ~~~
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

~~~
explain select * from clients as c where  exists (select id from orders as o where c.booking = o.id) ;

QUERY PLAN                                                            |
----------------------------------------------------------------------+
Hash Join  (cost=37.00..57.24 rows=810 width=72)                      |
  Hash Cond: (c.booking = o.id)                                       |
  ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)     |
  ->  Hash  (cost=22.00..22.00 rows=1200 width=4)                     |
        ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=4)|
~~~
Выводит информацию по запросу. Условия и их нагрузку.


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

## Ответ
~~~
docker exec -t pg-docker pg_dump -U postgres test_db -f /var/lib/postgresql/data/dump_test_db.sql
docker kill pg-docker 

docker run -d --rm --name pg-docker2 -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v vol1:/var/lib/postgresql/data -v vol2:/var/lib/postgresql postgres:12

docker exec -i pg-docker2 psql -U postgres -d test_db -f /var/lib/postgresql/data/dump_test_db.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
~~~

---


