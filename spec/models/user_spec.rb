require 'rails_helper'

RSpec.describe User, type: :model do
  describe "find_or_create_by_name" do
    it 'create a new user if a user with that name doesn\'t exist' do
      expect(User.find_or_create_by_name('bob').name).to eq 'bob'
    end

    it 'create a new user if a user with that name doesn\'t exist' do
      user = create(:user, name: 'jeff')
      expect(User.find_or_create_by_name('jeff')).to eq user
    end
  end
end
