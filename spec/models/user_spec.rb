require 'rails_helper'

describe User, type: :model do
  fixtures :users
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:status) }
  end

  it 'has attributes' do
    user = users(:user1)

    expect(user.name).to eq('Angela')
    expect(user.email).to eq('Bob@Bob.Bob')
  end
  it 'exists and defaults to inactive' do
    user = User.create(name: 'JP', email: 'JP@JP.JP', password: 'Hank')

    expect(user).to be_a(User)
    expect(user.status).to eq('inactive')
  end
end
