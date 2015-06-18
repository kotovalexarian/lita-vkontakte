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
      config :app_id,       type: String, required: true
      config :app_secret,   type: String, required: true
      config :access_token, type: String, required: true

      # Used version of VKontakte API.
      # {https://vk.com/dev/versions}
      API_VERSION = '5.34'

      # Needed for VKontakte authentication.
      REDIRECT_URI = 'https:/oauth.vk.com/blank.html'

      # Connects to VKontakte API.
      #
      # @param robot [Lita::Robot] The currently running robot.
      #
      def initialize(robot)
        super

        VkontakteApi.configure do |vk|
          vk.app_id       = config.app_id
          vk.app_secret   = config.app_secret
          vk.redirect_uri = REDIRECT_URI
          vk.api_version  = API_VERSION
        end

        @vk = VkontakteApi::Client.new(config.access_token)
      end

      # The main loop. Listens for incoming messages,
      # creates {Lita::Message} objects from them,
      # and dispatches them to the robot.
      #
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

      # Sends one or more messages to a user or room.
      #
      # @param target [Lita::Source] The user or room to send messages to.
      # @param messages [Array<String>] An array of messages to send.
      #
      def send_messages(target, messages)
        messages.reject(&:empty?).each do |message|
          send_message(target, message)
        end
      end

      protected

      # Handlers for events of VKontakte long poll server.
      # {https://vk.com/dev/using_longpoll}
      HANDLERS = {
        4 => :get_message,
      }

      # Handle event of VKontakte long poll server.
      # {https://vk.com/dev/using_longpoll}
      #
      # @param a [List] Event arguments.
      #
      def update(a)
        code = a[0]
        data = a[1..-1]

        method(HANDLERS[code]).call(*data) if HANDLERS[code]
      end

      # Handle new message
      # {https://vk.com/dev/using_longpoll}
      #
      # @param message_id [Integer] Message ID.
      # @param flags [Integer] Message flags.
      # @param from_id [Integer] ID of user who sent this message.
      # @param timestamp [Integer] Message time in UNIX format.
      # @param subject [String] Chat theme (" ... " for private messages).
      # @param text [String] Message text.
      # @param attachments [Hashie::Mash] Message attachments.
      #
      def get_message( # rubocop:disable Metrics/ParameterLists
        _message_id, flags, from_id, _timestamp, subject, text, _attachments
      )
        is_private = subject.start_with?(' ')
        is_own = flags & 2 != 0

        user = User.new(from_id)
        source = Source.new(user: user, room: subject)
        message = Message.new(robot, text, source)

        return if is_own

        message.command! if is_private
        robot.receive(message)
      end

      # Sends one message to a user or room.
      #
      # @param target [Lita::Source] The user or room to send message to.
      # @param messages [String] Messages to send.
      #
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
