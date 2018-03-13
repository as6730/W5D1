class User < ApplicationRecord
  def create

    user = User.new(user_params)
    if user.save
       sign_in((user)
      redirect_to links_url
    else
      flash[:errors] = user.errors.full_messagges
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
