require 'rails_helper'

RSpec.feature 'Users require location to shoutout' do
  specify 'users without location cannot shoutout' do
    user = create(:user, location: nil)
    response = post '/shoutout', user_name: user.name, text: '@person, thanks'
    expect(response.location).to include('/users/location_missing')
  end

  specify 'users with a location are able to shoutout' do
    user = create(:user, location: 'landantown')
    response = post '/shoutout', user_name: user.name, text: '@person, thanks'
    expect(response.body).to include('Shoutout to person saved')
  end
end

RSpec.feature 'User can update location' do
  specify 'users can set location' do
    response = post '/users/set_location', user_name: 'name', text: 'london'
    expect(response.body).to include('You\'re the first person')
  end

  specify 'users are warned when updating to same location' do
    create(:user, name: 'name', location: 'london')
    response = post '/users/set_location', user_name: 'name', text: 'london'
    expect(response.body).to include('But you\'re already in')
  end

  specify 'users are told if another user is at their location' do
    create(:user)
    response = post '/users/set_location', user_name: 'new_user', text: 'london'
    expect(response.body).to include('another')
  end

  specify 'users are told count of others at their location' do
    3.times { create(:user) }
    response = post '/users/set_location', user_name: 'new_user', text: 'london'
    expect(response.body).to include('3 others')
  end
end

