require 'rails_helper'

describe 'POST /api/v1/games' do
  it 'user can create a game' do
    user1 = User.create(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: 'Hello')
    user2 = User.create(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: 'Goodbye')

    allow(user1).to receive(:api_key).and_return('Hello')

    json_payload = {opponent_email: user2.email}.to_json
    headers = {"X-API-Key" => user1.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games", params: json_payload, headers: headers

    expect(response).to be_success
    expect(Game.last.id).to eq(1)
    expect(Game.last.player_1_key).to eq(user1.api_key)
    expect(Game.last.player_2_key).to eq(user2.api_key)
  end
end
