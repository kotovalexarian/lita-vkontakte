describe Lita::Adapters::Vkontakte, lita: true do
  subject { described_class.new(robot) }

  let(:robot) { Lita::Robot.new(registry) }

  before do
    registry.register_adapter(:vkontakte, described_class)

    registry.configure do |config|
      config.adapters.vkontakte.client_id     = client_id
      config.adapters.vkontakte.client_secret = client_secret
      config.adapters.vkontakte.access_token  = access_token
    end
  end

  let(:client_id)     { ENV['LITA_VK_CLIENT_ID'] }
  let(:client_secret) { ENV['LITA_VK_CLIENT_SECRET'] }
  let(:access_token)  { ENV['LITA_VK_ACCESS_TOKEN'] }

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
