Lita::Adapters::Vkontakte
=========================

[:gb::ru:Read in English](README.md)

[![Gem Version](https://badge.fury.io/rb/lita-vkontakte.svg)](http://badge.fury.io/rb/lita-vkontakte)
[![Build Status](https://travis-ci.org/braiden-vasco/lita-vkontakte.svg)](https://travis-ci.org/braiden-vasco/lita-vkontakte)
[![Coverage Status](https://coveralls.io/repos/braiden-vasco/lita-vkontakte/badge.svg)](https://coveralls.io/r/braiden-vasco/lita-vkontakte)

Адаптер [ВКонтакте](https://vk.com) для чат-бота [Lita](http://lita.io).

Инструкция
----------

Сперва ознакомьтесь с документацией Lita: http://docs.lita.io/

### Установка

Добавьте **lita-vkontakte** в Gemfile вашего экземпляра Lita:

```ruby
gem 'lita-vkontakte', '~> 1.1.0'
```

### Подготовка

Перейдите на https://vk.com/editapp?act=create и создайте Standalone-приложение.
Затем перейдите на страницу настроек приложения и запишите куда-нибудь
указанные там ID приложения и защищённый ключ.

Откройте темпинал и введите следующую команду
(заменяя `$LITA_VK_APP_ID` на ID приложения):

```sh
$ lita-vkontakte $LITA_VK_APP_ID
```

В терминал будет выведена ссылка. Откройте её в браузере, в котором вы
авторизованы как пользователь, который будет вашим чат-ботом.
Вы будете перенаправлены на страницу с предупреждением.
Запишите куда-нибудь параметр `access_token` из адреса страницы,
на которую вы были перенаправлены.

### Конфигурация

#### Обязательные аттрибуты

- `app_id` (String) - ID приложения
- `app_secret` (String) - защищённый ключ
- `access_token` (String) - параметр `access_token` из адреcа страницы

#### Пример

Пример файла `lita_config.rb`:

```ruby
Lita.configure do |config|
  config.robot.name = 'Lita'
  config.robot.mention_name = 'lita'

  config.robot.adapter = :vkontakte

  config.adapters.vkontakte.app_id     = '2849670'
  config.adapters.vkontakte.app_secret = 'EtgJI2yFJ0GYzgDLSS8e'
  config.adapters.vkontakte.access_token  = '51jeIbjmmxJvKo7TTaW0Ext4cx6ajonDIbEkSjFofh7boyxH27JcjKXMODwZTaOxLA1bQbRyY0CEUM2TrXGK6'
end
```
