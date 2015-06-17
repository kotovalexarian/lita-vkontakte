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

      def run # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        loop do
          session = @vk.messages.get_long_poll_server
          url = 'http://' + session.delete(:server)
          params = session.merge(act: 'a_check', wait: 25, mode: 2)
          params.ts = @ts if @ts

          response = nil

          get_response = lambda do
            response = VkontakteApi::API.connection.get(url, params).body
          end

          while get_response.call
            break if response.failed?
            params.ts = @ts = response.ts
          end
        end
      end
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
