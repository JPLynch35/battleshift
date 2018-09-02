require 'rails_helper'

describe 'GET /verification' do
  it 'changes user status upon verification' do
    user = User.create(name: 'Jorj', email: 'jorj@jorj.com', password: 'jorj', api_key: 'realapikey')

    params = { 'api_key' => user.api_key }
    get "/verification", params: params

    expect(User.last.status).to eq('active')
  end
end
