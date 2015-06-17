require 'lita'

Lita.load_locales(Dir[File.expand_path('../../locales/*.yml', __FILE__)])

require 'lita/adapters/vkontakte/version'

module Lita
  module Adapters # rubocop:disable Style/Documentation
    class Vkontakte < Adapter
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
