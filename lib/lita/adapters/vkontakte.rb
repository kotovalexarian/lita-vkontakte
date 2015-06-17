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
      config :client_id,     type: String, required: true
      config :client_secret, type: String, required: true
      config :access_token,  type: String, required: true
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
