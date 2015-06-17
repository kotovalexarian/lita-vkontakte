require 'lita'

require 'vkontakte_api'

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
      API_VERSION = '5.34'

      REDIRECT_URI = 'https:/oauth.vk.com/blank.html'

      config :client_id,     type: String, required: true
      config :client_secret, type: String, required: true
      config :access_token,  type: String, required: true

      def initialize(robot)
        super

        VkontakteApi.configure do |vk|
          vk.app_id       = config.client_id
          vk.app_secret   = config.client_secret
          vk.redirect_uri = REDIRECT_URI
          vk.api_version  = API_VERSION
        end

        @vk = VkontakteApi::Client.new(config.access_token)
      end
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
