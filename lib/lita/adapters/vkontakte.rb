require 'lita'
require 'vkontakte_api'
require 'securerandom'

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
        robot.trigger(:connected)

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

            response.updates.each(&method(:update))
          end
        end

      ensure
        robot.trigger(:disconnected)
      end

      def send_messages(target, messages)
        messages.reject(&:empty?).each do |message|
          send_message(target, message)
        end
      end

      protected

      HANDLERS = {
        4 => :get_message,
      }

      def update(a)
        code = a[0]
        data = a[1..-1]

        method(HANDLERS[code]).call(*data) if HANDLERS[code]
      end

      def get_message(_msg_id, _flags, # rubocop:disable Metrics/ParameterLists
                      from_id, _timestamp, subject,
                      text, _attachments
                     )
        is_private = subject.start_with?(' ')

        user = User.new(from_id)
        source = Source.new(user: user, room: subject)
        message = Message.new(robot, text, source)

        message.command! if is_private
        robot.receive(message)
      end

      def send_message(target, message) # rubocop:disable Metrics/AbcSize
        is_private = target.room.start_with?(' ')

        @vk.messages.send({
          message: message,
          guid: SecureRandom.random_number(2**31),
          user_id: (target.user.id.to_i                     if is_private),
          chat_id: (target.user.id.to_i - 2_000_000_000 unless is_private),
        }.reject { |_, v| v.nil? })
      end
    end

    Lita.register_adapter(:vkontakte, Vkontakte)
  end
end
