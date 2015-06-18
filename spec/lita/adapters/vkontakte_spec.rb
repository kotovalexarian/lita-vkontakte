describe Lita::Adapters::Vkontakte, lita: true do
  subject { described_class.new(robot) }

  let(:robot) { Lita::Robot.new(registry) }

  before do
    registry.register_adapter(:vkontakte, described_class)

    registry.configure do |config|
      config.adapters.vkontakte.app_id       = app_id
      config.adapters.vkontakte.app_secret   = app_secret
      config.adapters.vkontakte.access_token = access_token
    end
  end

  let(:app_id)       { ENV['LITA_VK_APP_ID'] }
  let(:app_secret)   { ENV['LITA_VK_APP_SECRET'] }
  let(:access_token) { ENV['LITA_VK_ACCESS_TOKEN'] }

  it 'registers Lita adapter "vkontakte"' do
    expect(Lita.adapters[:vkontakte]).to eq described_class
  end

  describe '#initialize' do
    it 'runs successful' do
      expect { described_class.new(robot) }.to_not raise_error
    end

    it 'creates VKontakte API client' do
      expect(
        described_class.new(robot).instance_variable_get(:@vk)
      ).to be_instance_of VkontakteApi::Client
    end
  end
end
