class StaticPagesController < ApplicationController
require 'httparty'
  def signin
    HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).body

  end

  def register
  end

  def movies
    @movies=JSON.parse(open("http://flavumovies.herokuapp.com/movies.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @rm=@movies['remaining_movies']
    @im=@movies['interested_movies']
    @nim=@movies['not_interested_movies']
  end

  def theatres
    @theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
    @lt=@theatres['liked_theatres']
    @nt=@theatres['nearby_theatres']
    @nit=@theatres['not_interested_theatres']
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
  end

  def buddies
    @followers=JSON.parse(open("http://flavumovies.herokuapp.com/followers.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read)
    @followees=JSON.parse(open("http://flavumovies.herokuapp.com/followees.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read)
    @requests=JSON.parse(open("http://flavumovies.herokuapp.com/requests.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read)
    @blockees=JSON.parse(open("http://flavumovies.herokuapp.com/blockees.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read)
    @fw1=@followers['followers']
    @fw2=@followees['followees']
    @rq=@requests['friends_requests']
    @bk1=@blockees['blockees']
  end

  def home
  end
end
