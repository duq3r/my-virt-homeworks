# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Ответ 1 <br>

Dockerfile
~~~
FROM centos:7
ENV ELASTICSEARCH_VERSION=7.12.1
ENV ELASTICSEARCH_USER=es
RUN adduser $ELASTICSEARCH_USER
RUN \
  yum install -y wget perl-Digest-SHA && \
  yum clean all && \
  rm -rf /var/cache
RUN install -o $ELASTICSEARCH_USER -g $ELASTICSEARCH_USER -d /var/lib/elasticsearch
USER $ELASTICSEARCH_USER
WORKDIR /home/$ELASTICSEARCH_USER
RUN \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  rm -f elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz*
RUN \
  sed -i 's/^#node.name.*/node.name: \${NODENAME}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  sed -i 's/^#path.data.*/path.data: \${PATHDATA}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  echo 'http.bind_host: 0.0.0.0' >> elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["elasticsearch-${ELASTICSEARCH_VERSION}/bin/elasticsearch"]


Ссылка на образ duq3r/elastic

curl http://localhost:9200

{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "d-sPNwfjRX6gqRpIlHmzZA",
  "version" : {
    "number" : "7.12.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3186837139b9c6b6d23c3200870651f10d3343b7",
    "build_date" : "2021-04-20T20:56:39.040728659Z",
    "build_snapshot" : false,
    "lucene_version" : "8.8.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

~~~



## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1 | 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Ответ 2 <br>

~~~
curl -X PUT "http://localhost:9200/ind-1" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 1,
    "number_of_replicas" : 0
  }
}
'

curl -X PUT "http://localhost:9200/ind-2" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 2,
    "number_of_replicas" : 1
  }
}
'

curl -X PUT "http://localhost:9200/ind-3" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 4,
    "number_of_replicas" : 2
  }
}
'
~~~

curl "http://localhost:9200/_cat/indices"
```
green  open ind-1 Kpkp2VVJSWi1WffKvEy9-w 1 0 0 0 208b 208b
yellow open ind-3 dwQdLlnUQvK-aqcBzfw1lQ 4 2 0 0 832b 832b
yellow open ind-2 T4fKf4FUSlCOp5dsg9EQjA 2 1 0 0 416b 416b
```

curl "http://localhost:9200/_cluster/health?pretty=true"
```
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 7,
  "active_shards" : 7,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
```

Индексы ind-2 и ind-3 находятся в состоянии yellow, тк они не реплицировались на указанное количство реплик (реплики у нас не подняты)

```
curl -X DELETE "http://localhost:9200/ind*"
```
## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

## Ответ 3 

~~~
curl -X PUT "http://localhost:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d '
{
  "type": "fs",
  "settings": {
    "location": "netology_backup"
  }
}
'

{"acknowledged":true}

curl -X PUT "http://localhost:9200/test" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 1,
    "number_of_replicas" : 0
  }
}
'

curl "http://localhost:9200/_cat/indices"
green open test J27BUVtMSA28DqCjC5XjKw 1 0 0 0 208b 208b


curl -X PUT "http://localhost:9200/_snapshot/netology_backup/snapshot_1"

index-0
index.latest
indices
meta-aUP4Ud66RjOyNJkcYj6tcw.dat
snap-aUP4Ud66RjOyNJkcYj6tcw.dat


curl -X DELETE "http://localhost:9200/test"
curl -X PUT "http://localhost:9200/test-2"
curl "http://localhost:9200/_cat/indices"
yellow open test-2 Zrfwt92RRUC9FfZTjO4ALQ 1 1 0 0 208b 208b

curl -X POST "http://localhost:9200/_snapshot/netology_backup/snapshot_1/_restore"
curl "http://localhost:9200/_cat/indices"

yellow open test-2 Zrfwt92RRUC9FfZTjO4ALQ 1 1 0 0 208b 208b
green  open test   BEaUImFzSMGEhSxoFOfa8g 1 0 0 0 208b 208b
~~~

---





