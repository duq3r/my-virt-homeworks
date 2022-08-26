
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
<b><br>- Можно быстро разворачивать сетевую и серверную инфраструктуру. Ускорение вывода продукта на рынок. Стабильность среды и устранение дрейфа конфигураций, сохранение всех изменений и возможность откатиться к любой предыдущей версии. Всё это позволяет добиться более быстрой и эффективной разработки. Главное преимущество - идемпотентность создаваемой инфраструктуры, т.е. при выполнении кода мы получаем всегда идентичнтичный результат. </b>
- Какой из принципов IaaC является основополагающим?
<b><br>- Принцип описания инфраструктуры кодом подобно практике из разработки ПО.   
П.С.
Не совсем понял, что писать в ответе. Направьте и я допишу если что.</b>
  
  ## Ответ

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
  <br>-Ansible удобен в использовании и у него простой интерфейс. Подходит для быстрого понимания мистемными инженерами
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
  <br>-Надёжней, наверное pull метод. Т.к. система сама запрашивает свою конфигурацию, проверяет её и потом обновляет инфраструктуру. Таким образом меньше шансов, что мы ничайно запушим не верный конфиг в систему.

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible
  
*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Ответ

- VirtualBox
  <br>Графический интерфейс VirtualBox
Версия 6.1.30 r148432 (Qt5.6.2)
- Vagrant
  <br> H:\>Vagrant --version
Vagrant 2.2.19
- Ansible
<br> Provision сделан через плагин вагранта ansible_local
  <br>vagrant@server1:~$ ansible --version
ansible [core 2.12.8]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/vagrant/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
  jinja version = 2.10.1
  libyaml = True


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps

#Ответ

vagrant@server1:~/$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```