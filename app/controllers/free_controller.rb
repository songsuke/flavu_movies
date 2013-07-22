class FreeController < ApplicationController
	layout 'free'
	def free
		@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    	@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
    	@rm=@movies['remaining_movies']
		@id_showmovie=session[:showid].to_i
		puts @id_showmovie
		puts session[:showid]
	end
end
