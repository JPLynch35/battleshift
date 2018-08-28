class VerificationController < ApplicationController
  def show
    user = User.find_by_api_key(params[:api_key])
    if user
      user.update_attribute(:status, 1)
    end
  end
end
