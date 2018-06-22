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

  describe "Posting a message to a cheered user" do
    let (:client) { double(:slack_client) }
    subject { described_class.new(client) }

    it "should call cheered user with expected parameters" do
      allow(client).to receive(:users_list).with(token: 'not_a_token').and_return({"members"=>[{'name'=>'user', 'id'=>'1'}]})
      expect(client).to receive(:chat_postMessage).with(channel: '1', text: 'you got cheered!', as_user: true)
      subject.post_direct_message('not_a_token', ['user'], 'you got cheered!')
    end
  end
end
