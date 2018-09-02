require 'rails_helper'

describe 'a user' do
  describe 'visiting the root page' do
    it 'can register for an account' do
      visit '/'
      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in :user_name, with: 'Bob'
      fill_in :user_email, with: 'Bob@Bob.Bob'
      fill_in :user_password, with: 'Ben'
      fill_in :user_password_confirmation, with: 'Ben'
      click_on 'Submit'

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content('Logged in as Bob')
      expect(page).to have_content('This account has not yet been activated. Please check your email.')
      expect(User.last.api_key).to be_a(String)
    end
    it 'cannot register n account without all required information' do
      visit '/'
      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in :user_name, with: 'Bob'
      fill_in :user_password, with: 'Ben'
      fill_in :user_password_confirmation, with: 'Ben'
      click_on 'Submit'

      expect(page).to have_content('Create a new account')
    end
  end
end
