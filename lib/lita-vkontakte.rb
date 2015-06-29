require 'lita'

Lita.load_locales(Dir[File.expand_path('../../locales/*.yml', __FILE__)])

require 'lita/adapters/vkontakte'
