require 'rails_helper'

describe 'POST /api/v1/games' do
  it 'user can create a game' do
    user1 = User.create!(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob', status: 1, api_key: SecureRandom.hex(32))
    user2 = User.create!(name: 'JP', email: 'JP@Bob.Bob', password: 'JP', status: 1, api_key: SecureRandom.hex(32))

    # Faraday.post '/api/v1/games' do |faraday|
    #   faraday.headers["X-API-Key"] = user1.api_key
    #   faraday.body = {opponent_email: user2.email}
    # end

    json_payload = {opponent_email: user2.email}.to_json
    headers = {"X-API-Key" => user1.api_key, "CONTENT_TYPE" => "application/json" }

    post "/api/v1/games", params: json_payload, headers: headers

    expect(response).to be_success

  end
end
