require 'rails_helper'

RSpec.describe SlackService, type: :service do

  describe "Posting a message to a channel" do
    let(:client) { double(:slack_client) }
    subject { described_class.new(client) }

    it 'should call slack client with expected parameters' do
      expect(client).to receive(:chat_postMessage).with(channel: 'london', text: 'cheers!', as_user: true)
      subject.post_message('london', 'cheers!')
    end
  end
end
