Lita::Adapters::Vkontakte
=========================

[![Gem Version](https://badge.fury.io/rb/lita-vkontakte.svg)](http://badge.fury.io/rb/lita-vkontakte)
[![Build Status](https://travis-ci.org/braiden-vasco/lita-vkontakte.svg)](https://travis-ci.org/braiden-vasco/lita-vkontakte)
[![Coverage Status](https://coveralls.io/repos/braiden-vasco/lita-vkontakte/badge.svg)](https://coveralls.io/r/braiden-vasco/lita-vkontakte)

[VKontakte](https://vk.com) adapter for the [Lita](https://lita.io) chat bot.

Usage
-----

At first, see the documentation for Lita: https://docs.lita.io/

### Installation

Add **lita-vkontakte** to your Lita instance's Gemfile:

```ruby
gem "lita-vkontakte"
```

### Preparation

Go to https://vk.com/editapp?act=create and create standalone application.
Then go to application settings page and look at application ID and secure key.

Open the Ruby console (for example with `irb` command) and type the following
(replace `LITA_VK_CLIENT_ID` with your application ID):

```ruby
require 'vkontakte_api'

VkontakteApi.app_id = "LITA_VK_CLIENT_ID"
VkontakteApi.redirect_uri = 'https://oauth.vk.com/blank.html'

puts VkontakteApi.authorization_url(type: :client, scope: [:offline, :messages])
```

You will see a link. Open it in browser where you are authorized in VKontakte
as your future chat bot's user. You will be redirected to some address.
We need a parameter `access_token` from this URL.

### Configuration

#### Required attributes

- `client_id` (String) - An ID of your application
- `client_secret` (String) - A secure key of your application
- `access_token` (String) - An acces token from URL

#### Example

This is an example `lita_config.rb` file:

```ruby
Lita.configure do |config|
  config.robot.name = 'Lita'
  config.robot.mention_name = 'lita'

  config.robot.adapter = :vkontakte

  config.adapters.vkontakte.client_id     = '2849670'
  config.adapters.vkontakte.client_secret = 'EtgJI2yFJ0GYzgDLSS8e'
  config.adapters.vkontakte.access_token  = '51jeIbjmmxJvKo7TTaW0Ext4cx6ajonDIbEkSjFofh7boyxH27JcjKXMODwZTaOxLA1bQbRyY0CEUM2TrXGK6'
end
```
