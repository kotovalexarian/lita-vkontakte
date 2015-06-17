require 'lita'

require 'lita/adapters/vkontakte/version'

module Lita
  module Adapters # rubocop:disable Style/Documentation
    class Vkontakte < Adapter
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
