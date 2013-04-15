class StaticPagesController < ApplicationController
require 'httparty'
  def signin
    puts "my param #{params[:login]}"
   
    @users =HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 


    puts @users
    @auth_token=@users['auth_token']
    session[:username] = @users['username']
    session[:user] = @users
    session[:auth] = @auth_token
    session[:latitude] = '49.28385281'
    session[:longitude] = '-123.1120815'
    @username=session[:username]
    @auth=session[:auth]
    
    
  end

  def register
    @users_registations =HTTParty.post("http://flavumovies.herokuapp.com/users.json", body: {user: {password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email]}}).parsed_response
    puts "my param #{params[:username]}"
    puts @users_registations
  end

  def movies
    @a1=session[:auth]
    @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    
    @movies =HTTParty.get(@url, body: {user: {auth_token: @a1}}).parsed_response

    @rm=@movies['remaining_movies']
    @im=@movies['interested_movies']
    @nim=@movies['not_interested_movies']
  end

  def theatres
    @a1=session[:auth]
    @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @theatres =HTTParty.get(@url, body: {user: {auth_token: @a1}}).parsed_response

    #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @lt=@theatres['liked_theatres']
    @nt=@theatres['nearby_theatres']
    @nit=@theatres['not_interested_theatres']
  end
  def buddies

    @a1=session[:auth]

    @url1 = "http://flavumovies.herokuapp.com/followers.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @followers =HTTParty.get(@url1, body: {user: {auth_token: @a1}}).parsed_response
    @url2 = "http://flavumovies.herokuapp.com/followees.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @followees =HTTParty.get(@url2, body: {user: {auth_token: @a1}}).parsed_response
    @url3 = "http://flavumovies.herokuapp.com/requests.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @requests =HTTParty.get(@url3, body: {user: {auth_token: @a1}}).parsed_response
    @url4 = "http://flavumovies.herokuapp.com/blockees.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @blockees =HTTParty.get(@url4, body: {user: {auth_token: @a1}}).parsed_response

  #  @followers=JSON.parse(open("http://flavumovies.herokuapp.com/followers.json?auth_token=kczrVERyuJu6RgevHZCx").read)
   # @followees=JSON.parse(open("http://flavumovies.herokuapp.com/followees.json?auth_token=kczrVERyuJu6RgevHZCx").read)
  #  @requests=JSON.parse(open("http://flavumovies.herokuapp.com/requests.json?auth_token=kczrVERyuJu6RgevHZCx").read)
  #  @blockees=JSON.parse(open("http://flavumovies.herokuapp.com/blockees.json?auth_token=kczrVERyuJu6RgevHZCx").read)
    @fw1=@followers['followers']
    @fw2=@followees['followees']
    @rq=@requests['friends_requests']
    @bk1=@blockees['blockees']
  
  end

  def preferences
    @genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @director_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/director_preferences.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @actor_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/actor_preferences.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @gp=@genre_preferences['genre_preferences']
    @dp=@director_preferences['director_preferences']
    @ap=@actor_preferences['actor_preferences']

  end
  def edit

    
    
  end
  def settings 

    @a1=session[:auth]
    @user=session[:user]
    puts session[:auth]
    puts @a1
    @setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
      body: {user: {auth_token: @a1, 
        email: params[:email], 
        username: params[:username], 
        display_name: params[:display_name],
        phone_number: params[:phone_number],
        password: params[:password],
        password_confirmation: params[:password_confirmation]}}).parsed_response
    puts @setting_account

  end

  def home
  end

  def signout
    reset_session    
    redirect_to root_url
  end


  def cover
    #@guests =HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: 'true'}}).parsed_response 
    @guests1 =HTTParty.get("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: "true"}}).parsed_response 
    puts @guests1
    #puts @guests['auth_token']


  end



end
