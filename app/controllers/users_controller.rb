class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      @user.api_key = SecureRandom.hex(32)
      @user.save
      VerificationNotifierMailer.verify(@user).deliver_now
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
