require "rails_helper"

describe VerificationNotifierMailer, type: :mailer do

  describe 'verify' do
    let(:user) { User.create(name: 'Jorj', email: 'jorj@jorj.com', password: 'jorj')}
    let(:mail) { described_class.verify(user).deliver_now }

    it 'renders subject' do
      expect(mail.subject).to eq('BattleShift Verification')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['no-reply@battleshift.com'])
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to match("http://localhost:3000/verification")
    end

  end
end
