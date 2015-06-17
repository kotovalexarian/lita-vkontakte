require 'lita'

##
# Lita module.
#
module Lita
  ##
  # Lita adapters module.
  #
  module Adapters
    ##
    # VKontakte adapter for the Lita chat bot.
    #
    class Vkontakte < Adapter
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
