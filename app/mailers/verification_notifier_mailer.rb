class VerificationNotifierMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def verify(user)
    @user = user
    mail(to: @user.email, subject: 'BattleShift Verification')
  end
end
