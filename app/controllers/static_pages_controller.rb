class StaticPagesController < ApplicationController
  def signin
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
  end

  def preferences
  end

  def settings
  end

  def buddies
  end

  def home
  end
end
