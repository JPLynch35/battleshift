require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:status) }
  end

  it 'exists and defaults to inactive' do
    user = User.new(name: 'Angela', email: 'Bob@Bob.Bob', password: 'Bob')

    expect(user).to be_a(User)
    expect(user.status).to eq('inactive')
  end

end
