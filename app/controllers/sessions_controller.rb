class SessionsController < ApplicationController
  def index
    
  end

  def create
    #accepts OAuth information from Spotify, finds or creates a User account, and sets user_id in session
    auth_hash = request.env['omniauth.auth']   #request is a variable that you get
    @user = User.find_or_create_from_omniauth(auth_hash)
    binding.pry
    # user = User.log_in(params[:xemail], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    #deletes user_id from session
    session.delete :user_id
    redirect_to root_path
  end

end
