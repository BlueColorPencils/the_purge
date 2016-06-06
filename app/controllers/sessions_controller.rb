class SessionsController < ApplicationController
  def index

  end

  def new_search
    @search = params[:query].downcase.delete(" ")

    if current_user
      auth_hash = request.env['omniauth.auth']

      @graph = Koala::Facebook::API.new(current_user.oauth_token)
      @timeline = @graph.get_object("me?fields=feed.limit(2000){from,message,permalink_url,with_tags,picture,created_time,type,comments.limit(100)}")

      @posts = @timeline["feed"]["data"]
      @posts_including_person = {}
      @hash_count = 0
      #for each message...
      @posts.length.times do |count|
        if @posts[count].to_s.gsub!(/[^0-9A-Za-z]/, '').downcase.include? @search
          @posts_including_person[@hash_count] = @posts[count]
          @hash_count += 1
        end
      end

    end
  end

  def create
    #accepts OAuth information from Spotify, finds or creates a User account, and sets user_id in session
    auth_hash = request.env['omniauth.auth']   #request is a variable that you get
    @user = User.find_or_create_from_omniauth(auth_hash)
    # @meow = stalk

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

  def stalk

  end

end
