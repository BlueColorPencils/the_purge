class SessionsController < ApplicationController
  def index

  end

  def new_search
    @search = params[:query].downcase.delete(" ")

  if current_user
    auth_hash = request.env['omniauth.auth']

    @graph = Koala::Facebook::API.new(current_user.oauth_token)
    @timeline = @graph.get_object("me?fields=feed.limit(2000){from,message,permalink_url,with_tags,picture,created_time,type,comments}")

    @posts = @timeline["feed"]["data"]
    @posts_including_person = {}
    #for each message...
    @posts.length.times do |count|
      if @posts[count].to_s.gsub!(/[^0-9A-Za-z]/, '').downcase.include? @search
        @posts_including_person[count] = @posts[count]
      end
    end
      # @exists = 0
      #
      # @posts[count]["type"] ==
      # #1. is there a message?
      # if !@posts[count]["message"].nil? && @posts[count]["message"].downcase.include?@search
      #   #if the message contains that PERSON
      #   @exists += 1
      #     # @posts_including_person[count] = @posts[count]
      # elsif !@posts[count]["message"].nil? && @posts[count]["message"].downcase.include?@search
      # end
      #
      # #if you have tagged that PERSON in a post.
      # @posts[count]["with_tags"]["data"][0]["name"]
      #
      # #if it has comments check to see if PERSON commented.
      # if @posts[count].keys.include?"comments"
      #   # shortened the hash so it's easier to search
      #   @comments = @posts[count]["comments"]["data"]
      #   # loop through all comments to see if PERSON posted or is included in the message
      #   @comments.times do |comment|
      #     if @comments[comment]["from"]["name"] || @comments[comment]["comments"]
      #       #if its true, store the post and comment from that person
      #       [@comments[comment]["comments"]["data"]]
      #       [@comments[comment]["from"]["name"], @comments[comment]["from"]["id"] ]
      #       @posts["posts"]["data"][10]["comments"]["data"][1]["from"]
      #     end
      #   end
      # end

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
