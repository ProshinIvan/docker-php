# docker-php
Разворот контейнеров для разработки на php
Туть я сделал по инструкции, но обдумано!. Nginx + MySQl + php 8.4

Поднять все дело - make up - оно и билдит, и поднимает. Опустить - make down
Команды make описаны в make файле.

Не забудь поправить путь к index.php в nginx, когда будешь делать новй проект

composer create-project laravel/laravel:^11.0 example-app - команду вводишь в контейнере php (только не заубудь exmaple-app поменять) 

В .env Laravel в настройках подлючения к бд надо в поле DB_HOST = "имя sql контейнера" - в данной сборке - sql, т.е. 

B_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=test
DB_USERNAME=root
DB_PASSWORD=root

- пример подключения к бд с именем test
