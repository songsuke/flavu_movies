class StaticPagesController < ApplicationController
require 'httparty'
require 'open-uri'

  def signin
    #if (session[:auth] && session[:guest_auth])
     # redirect_to home_path
    if params[:confirm] !="confirm"
    else
      session[:check_guest] = "false"
      puts "my param #{params[:login]}"
      @users =httpsarty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
      puts @users.first[0]
      if (@users.first[0]=="error")
        flash[:error] = "Username or Password is wrong. Please try again"
      else
        puts @users
        @auth_token=@users['auth_token']
        session[:username] = @users['username']
        session[:user] = @users
        session[:auth] = @auth_token
        #session[:latitude] = '49.28385281'
       # session[:longitude] = '-123.1120815'
        @username=session[:username]
        @auth=session[:auth]
        redirect_to home_path
      end
    end
    
  end

  def register
    if session[:check_guest] == 'true'
        #showtime
          #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      puts params[:confirm]
      if params[:confirm] !="confirm"
      else
        if (params[:password].length < 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        else
          @users_registations =httpsarty.put("https://flavumovies.herokuapp.com/users.json", body: {user: {auth_token: session[:guest_auth], password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email], guest: "false"}}).parsed_response
          if (@users_registations['errors'])
            @check_register='false'
            flash[:error] = "#{params[:email]} has already been taken. Please try again"
          else
         # puts @users_registations['errors']['email']
            flash[:notice] = "Register is successful. Please check you email."
            redirect_to validate_path
          end
     # puts @users_registations
     # puts params[:email] 
     # @email=params[:email]
     # puts params[:password].length
        end
      end
    
      #puts @users_registations
      #puts params[:email] 
      #@email=params[:email]
      #puts @users_registations['errors']['email']
      
    else

      #showtime
          #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      puts params[:confirm]
      if params[:confirm] !="confirm"
      else
        if (params[:password].length <= 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        else
          @users_registations =httpsarty.post("https://flavumovies.herokuapp.com/users.json", body: {user: {password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email]}}).parsed_response
          if (@users_registations['errors'])
            @check_register='false'
            flash[:error] = "#{params[:email]} has already been taken. Please try again"
          else
         # puts @users_registations['errors']['email']
            flash[:notice] = "Register is successful. Please check you email."
            redirect_to validate_path
          end
     # puts @users_registations
     # puts params[:email] 
     # @email=params[:email]
     # puts params[:password].length
        end
      end
    end


  end

  def movies

    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
        #@a1=session[:auth]
        #puts session[:check_guest]
        #puts session[:auth]
        #puts session[:guest_auth]


        if session[:check_guest] == "true"
          #puts params[:liked]
          if params[:liked]
            @liked_movies =httpsarty.post("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, interested_movie: { movie_id:params[:liked]}}).parsed_response
          elsif params[:unliked]
            @unliked_movies =httpsarty.post("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, not_interested_movie: { movie_id:params[:unliked]}}).parsed_response
          elsif params[:soso1]
            @soso_movies =httpsarty.delete("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, interested_movie: { movie_id:params[:soso1]}}).parsed_response
          elsif params[:soso2]
            @soso_movies =httpsarty.delete("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, not_interested_movie: { movie_id:params[:soso2]}}).parsed_response

          else
          end
          #puts params[:watched]
          if params[:watched]
            @watched_movies =httpsarty.post("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:guest_auth]}, watched_movie: {movie_id:params[:watched] }}).parsed_response
          elsif params[:unwatched]
            @unwatched_movies =httpsarty.delete("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:guest_auth]}, watched_movie: {movie_id:params[:unwatched]}}).parsed_response
          end

           if params[:showid]
            session[:showid] = params[:showid]
            redirect_to showmovie_path
          else
          end
          @url = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =httpsarty.get(@url, body: {user: {auth_token: session[:guest_auth]  }, browser: "1"}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']

          #showtime
          #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          


        else
          #puts params[:liked]
          if params[:liked]
            @liked_movies =httpsarty.post("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:auth]}, interested_movie: { movie_id:params[:liked]}}).parsed_response
          elsif params[:unliked]
            @unliked_movies =httpsarty.post("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:auth]}, not_interested_movie: { movie_id:params[:unliked]}}).parsed_response
          elsif params[:soso1]
            @soso_movies =httpsarty.delete("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:auth]}, interested_movie: { movie_id:params[:soso1]}}).parsed_response
          elsif params[:soso2]
            @soso_movies =httpsarty.delete("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:auth]}, not_interested_movie: { movie_id:params[:soso2]}}).parsed_response

          else
          end
          #puts params[:watched]
          if params[:watched]
            @watched_movies =httpsarty.post("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:watched] }}).parsed_response
          elsif params[:unwatched]
            @unwatched_movies =httpsarty.delete("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:unwatched]}}).parsed_response
          end

           if params[:showid]
            session[:showid] = params[:showid]
            redirect_to showmovie_path
          else
          end
          @url = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =httpsarty.get(@url, body: {user: {auth_token: session[:auth]  }, browser: "1"}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']
          #showtime
          #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@rm=@movies['remaining_movies']
         
        end

      #puts params[:liked]
      #puts @liked_movies
    end

  end

  def theatres
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end

      @url = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response

      #@theatres=JSON.parse(open("https://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@rm=@movies['remaining_movies']


      else
        #puts params[:liked]
       # puts params[:unliked]
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end
      @url = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
      #puts @theatres
      #@theatres=JSON.parse(open("https://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@rm=@movies['remaining_movies']

      end
    end
  end

  def showtheatre
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      @url = "https://flavumovies.herokuapp.com/theatres/#{params[:showid]}.json"
      if session[:check_guest] == 'true'
        if params[:showid]
          @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        end

      else
        if params[:showid]
          @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        end
      end
      @st=@theatres['theatre']
    end
  end

  def buddies
    if (session[:auth])
    @a1=session[:auth]
    puts params[:request]
      if params[:request]
        @requesting =httpsarty.post("https://flavumovies.herokuapp.com/send_request.json", body: {user: {auth_token: @a1}, friend_contact_info: params[:request]}).parsed_response
      elsif params[:follow]
        @follow =httpsarty.post("https://flavumovies.herokuapp.com/friendships/follow.json?id=#{params[:follow]}", body: {user: {auth_token: @a1}}).parsed_response
      elsif params[:unfollow]
        @unfollow =httpsarty.post("https://flavumovies.herokuapp.com/friendships/unfollow.json?id=#{params[:unfollow]}", body: {user: {auth_token: @a1}}).parsed_response    
      elsif params[:accept_and_follow]
        @accept_and_follow =httpsarty.post("https://flavumovies.herokuapp.com/friendships/accept_and_follow.json?id=#{params[:accept_and_follow]}", body: {user: {auth_token: @a1}}).parsed_response
      elsif params[:accept]
        @accept =httpsarty.post("https://flavumovies.herokuapp.com/friendships/accept.json?id=#{params[:accept]}", body: {user: {auth_token: @a1}}).parsed_response
      elsif params[:reject]
        @reject =httpsarty.post("https://flavumovies.herokuapp.com/friendships/reject.json?id=#{params[:reject]}", body: {user: {auth_token: @a1}}).parsed_response
      #elsif params[:block]
        #@block =httpsarty.post("https://flavumovies.herokuapp.com/friendships/block.json?id=#{params[:block]}", body: {user: {auth_token: @a1}}).parsed_response
      #elsif params[:unblock]
        #@unblock =httpsarty.post("https://flavumovies.herokuapp.com/friendships/unblock.json?id=#{params[:unblock]}", body: {user: {auth_token: @a1}}).parsed_response
        #puts @unblock
      end
      @url1 = "https://flavumovies.herokuapp.com/followers.json"
      @followers =httpsarty.get(@url1, body: {user: {auth_token: @a1}}).parsed_response
      @url2 = "https://flavumovies.herokuapp.com/followees.json"
      @followees =httpsarty.get(@url2, body: {user: {auth_token: @a1}}).parsed_response
      @url3 = "https://flavumovies.herokuapp.com/requests.json"
      @requests =httpsarty.get(@url3, body: {user: {auth_token: @a1}}).parsed_response
      #@url4 = "https://flavumovies.herokuapp.com/blockees.json"
      #@blockees =httpsarty.get(@url4, body: {user: {auth_token: @a1}}).parsed_response
      
      @fw1=@followers['followers']
      @fw2=@followees['followees']
      @rq=@requests['friends_requests']
      #@bk1=@blockees['blockees']
      #@bk2=@blockers['blockers']
    #httpsarty.post("https://flavumovies.herokuapp.com/send_request.json", body: {user: {auth_token: "pb3BiqsJkvxbv2P3jnTR", friend_contact_info:"user1"}}).parsed_response
#puts params[:unblock]
   # puts params[:follow]
    #puts @following
   # puts params[:friend_contact_info]
    else
    end
  
  end

  def preferences

    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        puts "update = #{params[:update]}"
        puts "update1 =#{params[:genre_update]}"
        puts "delete= #{params[:delete]}"
        puts "create2=#{params[:create2]}"
        puts params[:director_create]
        if params[:create1] == "Create"
          @genre_create =httpsarty.post("https://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update] =="Update"
          @genre_update =httpsarty.put("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete] == "Delete"
          @genre_delete =httpsarty.delete("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create2] == "Create"
          @director_create =httpsarty.post("https://flavumovies.herokuapp.com/director_preferences.json", body: {user: {auth_token: session[:guest_auth]}, director_preference: {director: params[:director_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update2] =="Update"
          @director_update =httpsarty.put("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete2] == "Delete"
          @director_delete =httpsarty.delete("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create3] == "Create"
          @actor_create =httpsarty.post("https://flavumovies.herokuapp.com/actor_preferences.json", body: {user: {auth_token: session[:guest_auth]}, actor_preference: {actor: params[:actor_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update3] =="Update"
          @actor_update =httpsarty.put("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete3] == "Delete"
          @actor_delete =httpsarty.delete("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        end

        @url1 = "https://flavumovies.herokuapp.com/genre_preferences.json"
        @url2 = "https://flavumovies.herokuapp.com/director_preferences.json"
        @url3 = "https://flavumovies.herokuapp.com/actor_preferences.json"
        @genre_preferences =httpsarty.get(@url1, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @director_preferences =httpsarty.get(@url2, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @actor_preferences =httpsarty.get(@url3, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          
        @url4 = "https://flavumovies.herokuapp.com/genres.json"
        @all_genres =httpsarty.get(@url4, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @url5 = "https://flavumovies.herokuapp.com/directors.json"
        @all_directors =httpsarty.get(@url5, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @url6 = "https://flavumovies.herokuapp.com/actors.json"
        @all_actors =httpsarty.get(@url6, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']


      else
        ##puts params[:score]
        #@a1=session[:auth]
        #puts session[:auth]
        puts "update = #{params[:update2]}"
        puts "update1 =#{params[:director_update]}"
        puts "delete= #{params[:delete]}"
        puts "delete2= #{params[:delete2]}"
        puts "create2=#{params[:create2]}"
        puts params[:director_create]
        if params[:create1] == "Create"
          @genre_create =httpsarty.post("https://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update] =="Update"
          @genre_update =httpsarty.put("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete] == "Delete"
          @genre_delete =httpsarty.delete("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response

        elsif params[:create2] == "Create"
          @director_create =httpsarty.post("https://flavumovies.herokuapp.com/director_preferences.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update2] =="Update"
          @director_update =httpsarty.put("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete2] == "Delete"
          @director_delete =httpsarty.delete("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
          puts @director_delete
        elsif params[:create3] == "Create"
          @actor_create =httpsarty.post("https://flavumovies.herokuapp.com/actor_preferences.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update3] =="Update"
          @actor_update =httpsarty.put("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete3] == "Delete"
          @actor_delete =httpsarty.delete("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        end

        @url1 = "https://flavumovies.herokuapp.com/genre_preferences.json"
        @url2 = "https://flavumovies.herokuapp.com/director_preferences.json"
        @url3 = "https://flavumovies.herokuapp.com/actor_preferences.json"
        @genre_preferences =httpsarty.get(@url1, body: {user: {auth_token: session[:auth]}}).parsed_response
        @director_preferences =httpsarty.get(@url2, body: {user: {auth_token: session[:auth]}}).parsed_response
        @actor_preferences =httpsarty.get(@url3, body: {user: {auth_token: session[:auth]}}).parsed_response
          
        @url4 = "https://flavumovies.herokuapp.com/genres.json"
        @all_genres =httpsarty.get(@url4, body: {user: {auth_token: session[:auth]}}).parsed_response
        @url5 = "https://flavumovies.herokuapp.com/directors.json"
        @all_directors =httpsarty.get(@url5, body: {user: {auth_token: session[:auth]}}).parsed_response
        @url6 = "https://flavumovies.herokuapp.com/actors.json"
        @all_actors =httpsarty.get(@url6, body: {user: {auth_token: session[:auth]}}).parsed_response
        
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']
      end
    end
  end
  def edit
    reset_session
    redirect_to cover_path
  end

  def settings 
    puts session[:check_guest]
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        @user=session[:user]
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =httpsarty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        @show_genres = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie genres"}
        @show_actors = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie actors"}
        @show_directors = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie directors"}
        @show_rating_runtime = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie rating runtime"}
        @show_address = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre address"}
        @show_distance = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre distance"}
        @show_phone = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre phone"}
        @show_liked_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show liked theatres on map"}
        @show_nearby_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show nearby theatres on map"}
        @show_disliked_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show disliked theatres on map"}
      
        session[:SO_radius] ||= @radius["value"]
        session[:SO_unit] ||= @unit["value"]
        session[:MLO_genres] ||= @show_genres["value"]
        session[:MLO_actors] ||= @show_actors["value"]
        session[:MLO_directors] ||= @show_directors["value"]
        session[:MLO_raterun] ||= @show_rating_runtime["value"]
        session[:TLO_address] ||= @show_address["value"]
        session[:TLO_distance] ||= @show_distance["value"]
        session[:TLO_phone_number] ||= @show_phone["value"]
        session[:MO_liked_theatres] ||= @show_liked_theatres["value"]
        session[:MO_nearby_theatres] ||= @show_nearby_theatres["value"]
        session[:MO_disliked_theatres] ||= @show_disliked_theatres["value"]
          
        if params[:commit1] == "Update"
          @setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json",
          body: {user: {auth_token: session[:guest_auth], email: params[:email], 
            username: params[:username],
            display_name: params[:display_name],
            phone_number: params[:phone_number],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
            }}).parsed_response
          puts params[:email]
          #puts @setting_account['errors']['email'].first
          if (@setting_account['errors'])
            flash[:error1] = "Somgething is error. Please try again" 
            flash[:notice1] = nil
          else
            flash[:notice1] = "Update your account is successful"
            flash[:error1] = nil
          end

        #elsif params[:commit2] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], username: params[:username]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Update username is error. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your username is successful"   
            #flash[:error] = nil  
          #end

        #elsif params[:commit3] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], display_name: params[:display_name]}}).parsed_response
          #flash[:notice] = "Update your display name is successful"
          #flash[:notice] = nil

        #elsif params[:commit4] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], phone_number: params[:phone_number]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Your phone number has something wrong. Please try again" 
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your phone number is successful"
            #flash[:error] = nil
          #end

        #elsif params[:commit5] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], password: params[:password],
          #  password_confirmation: params[:password_confirmation]}}).parsed_response
          #if (params[:password].length <= 6)
            #flash[:error] = "Your password is too short. It has to be more than 6 characters"
            #flash[:notice] = nil
          #elsif params[:password] != params[:password_confirmation]
            #flash[:error] = "Your password do not match. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your password is successful" 
            #flash[:error] = nil
          #end

        elsif params[:commitSO] == "Update"
          if session[:SO_radius] != params[:radius].to_s
            httpsarty.put("#{@user_preference_url}/#{@radius['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @radius["preference"],
                  value: params[:radius]
                }
              }
            )
            session[:SO_radius] = params[:radius]
          end
          
          if session[:SO_unit] != params[:unit].to_s
            httpsarty.put("#{@user_preference_url}/#{@unit['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @unit["preference"],
                  value: params[:unit]
                }
              }
            )
            session[:SO_unit] = params[:unit]
          end
            
            #@user_preference =httpsarty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @a1}}).parsed_response
            #@radius_id = @user_preference['user_preferences'].third['id'].to_i
            #@unit_id = @user_preference['user_preferences'].last['id'].to_i
            #puts @radius_id
            #puts @unit_id
            #@radius2 =httpsarty.put("https://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json",
            #body: {
            #user: {auth_token: session[:auth]} ,
            #user_preference: {preference: "search radius", value: params[:radius]}
            #}).parsed_response
            #@unit2 =httpsarty.put("https://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json",
            #body: {
            #user: {auth_token: session[:auth]} ,
            #user_preference: {preference: "unit of measure", value: params[:unit]}
            #}).parsed_response
            
        elsif params[:commitMLO] == "Update"

            # TODO
            #if params[:genres]
          if session[:MLO_genres] != params[:genres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_genres['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_genres["preference"],
                  value: params[:genres]
                }
              }
            )
            session[:MLO_genres] = params[:genres]
          end
            
          if session[:MLO_actors] != params[:actors].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_actors['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_actors["preference"],
                  value: params[:actors]
                }
              }
            )
            session[:MLO_actors] = params[:actors]
          end
            
          if session[:MLO_directors] != params[:directors].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_directors['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_directors["preference"],
                  value: params[:directors]
                }
              }
            )
            session[:MLO_directors] = params[:directors]
          end
            
          if session[:MLO_raterun] != params[:raterun].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_rating_runtime['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_rating_runtime["preference"],
                  value: params[:raterun]
                }
              }
            )
            session[:MLO_raterun] = params[:raterun]
          end
            
            #if params[:actors]
            #session[:MLO_actors] = params[:actors]
            #puts "actors is #{session[:MLO_actors]}"
            #end
            #if params[:directors]
            #session[:MLO_directors] = params[:directors]
            #end
            #if params[:raterun]
            #session[:MLO_raterun] = params[:raterun]
            #end

        elsif params[:commitTLO] == "Update"

          if session[:TLO_address] != params[:address].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_address['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_address["preference"],
                  value: params[:address]
                }
              }
            )
            session[:TLO_address] = params[:address]
          end
            
          if session[:TLO_distance] != params[:distance].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_distance['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_distance["preference"],
                  value: params[:distance]
                }
              }
            )
            session[:TLO_distance] = params[:distance]
          end
            
          if session[:TLO_phone_number] != params[:phone_number].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_phone['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_phone["preference"],
                  value: params[:phone_number]
                }
              }
            )
            session[:TLO_phone_number] = params[:phone_number]
          end
            
            #if params[:address]
            #session[:TLO_address] = params[:address]
            #puts "address is #{session[:TLO_address]}"
            #end
            #if params[:phone_number]
            #session[:TLO_phone_number] = params[:phone_number]
            #puts "phone number is #{session[:TLO_phone_number]}"
            #end
            #if params[:distance]
            #session[:TLO_distance] = params[:distance]
            #end

        elsif params[:commitMO] == "Update"
          if session[:MO_liked_theatres] != params[:liked_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_liked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_liked_theatres["preference"],
                  value: params[:liked_theatres]
                }
              }
            )
            session[:MO_liked_theatres] = params[:liked_theatres]
          end
          
          if session[:MO_nearby_theatres] != params[:nearby_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_nearby_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_nearby_theatres["preference"],
                  value: params[:nearby_theatres]
                }
              }
            )
            session[:MO_nearby_theatres] = params[:nearby_theatres]
          end
            
          if session[:MO_disliked_theatres] != params[:disliked_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_disliked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:guest_auth]
                },
                user_preference: {
                  preference: @show_disliked_theatres["preference"],
                  value: params[:disliked_theatres]
                }
              }
            )
            session[:MO_disliked_theatres] = params[:disliked_theatres]
          end
            
            #if params[:likedt]
            #session[:MO_likedt] = params[:likedt]
            #puts "liked teatres is #{session[:MO_likedt]}"
            #end
            #if params[:near]
            #session[:MO_near] = params[:near]
            #puts "nearby theatres is #{session[:MO_near]}"
            #end
            #if params[:dist]
            #session[:MO_dist] = params[:dist]
            #end

        end#commit
      
        @account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
        body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          puts params[:commit1]
          puts params[:commit2]
      


      else
     #@a1=session[:auth]
        @user=session[:user]
       # puts session[:auth]
       # puts @a1
       
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =httpsarty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: session[:auth]}}).parsed_response
          
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        @show_genres = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie genres"}
        @show_actors = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie actors"}
        @show_directors = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie directors"}
        @show_rating_runtime = @user_preference["user_preferences"].find{|x| x["preference"] == "show movie rating runtime"}
        @show_address = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre address"}
        @show_distance = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre distance"}
        @show_phone = @user_preference["user_preferences"].find{|x| x["preference"] == "show theatre phone"}
        @show_liked_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show liked theatres on map"}
        @show_nearby_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show nearby theatres on map"}
        @show_disliked_theatres = @user_preference["user_preferences"].find{|x| x["preference"] == "show disliked theatres on map"}
      
        session[:SO_radius] ||= @radius["value"]
        session[:SO_unit] ||= @unit["value"]
        session[:MLO_genres] ||= @show_genres["value"]
        session[:MLO_actors] ||= @show_actors["value"]
        session[:MLO_directors] ||= @show_directors["value"]
        session[:MLO_raterun] ||= @show_rating_runtime["value"]
        session[:TLO_address] ||= @show_address["value"]
        session[:TLO_distance] ||= @show_distance["value"]
        session[:TLO_phone_number] ||= @show_phone["value"]
        session[:MO_liked_theatres] ||= @show_liked_theatres["value"]
        session[:MO_nearby_theatres] ||= @show_nearby_theatres["value"]
        session[:MO_disliked_theatres] ||= @show_disliked_theatres["value"]
          
        if params[:commit1] == "Update"
          @setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json",
          body: {user: {auth_token: session[:auth], email: params[:email], 
            username: params[:username],
            display_name: params[:display_name],
            phone_number: params[:phone_number],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
            }}).parsed_response
          puts params[:email]
          #puts @setting_account['errors']['email'].first
          if (@setting_account['errors'])
            flash[:error1] = "Somgething is error. Please try again" 
            flash[:notice1] = nil
          else
            flash[:notice1] = "Update your account is successful"
            flash[:error1] = nil
          end

        #elsif params[:commit2] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], username: params[:username]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Update username is error. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your username is successful"   
            #flash[:error] = nil  
          #end

        #elsif params[:commit3] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], display_name: params[:display_name]}}).parsed_response
          #flash[:notice] = "Update your display name is successful"
          #flash[:notice] = nil

        #elsif params[:commit4] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], phone_number: params[:phone_number]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Your phone number has something wrong. Please try again" 
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your phone number is successful"
            #flash[:error] = nil
          #end

        #elsif params[:commit5] == "Update"
          #@setting_account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: session[:auth], password: params[:password],
          #  password_confirmation: params[:password_confirmation]}}).parsed_response
          #if (params[:password].length <= 6)
            #flash[:error] = "Your password is too short. It has to be more than 6 characters"
            #flash[:notice] = nil
          #elsif params[:password] != params[:password_confirmation]
            #flash[:error] = "Your password do not match. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your password is successful" 
            #flash[:error] = nil
          #end

        elsif params[:commitSO] == "Update"
          if session[:SO_radius] != params[:radius].to_s
            httpsarty.put("#{@user_preference_url}/#{@radius['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @radius["preference"],
                  value: params[:radius]
                }
              }
            )
            session[:SO_radius] = params[:radius]
          end
          
          if session[:SO_unit] != params[:unit].to_s
            httpsarty.put("#{@user_preference_url}/#{@unit['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @unit["preference"],
                  value: params[:unit]
                }
              }
            )
            session[:SO_unit] = params[:unit]
          end
            
            #@user_preference =httpsarty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @a1}}).parsed_response
            #@radius_id = @user_preference['user_preferences'].third['id'].to_i
            #@unit_id = @user_preference['user_preferences'].last['id'].to_i
            #puts @radius_id
            #puts @unit_id
            #@radius2 =httpsarty.put("https://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json",
            #body: {
            #user: {auth_token: session[:auth]} ,
            #user_preference: {preference: "search radius", value: params[:radius]}
            #}).parsed_response
            #@unit2 =httpsarty.put("https://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json",
            #body: {
            #user: {auth_token: session[:auth]} ,
            #user_preference: {preference: "unit of measure", value: params[:unit]}
            #}).parsed_response
            
        elsif params[:commitMLO] == "Update"

            # TODO
            #if params[:genres]
          if session[:MLO_genres] != params[:genres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_genres['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_genres["preference"],
                  value: params[:genres]
                }
              }
            )
            session[:MLO_genres] = params[:genres]
          end
            
          if session[:MLO_actors] != params[:actors].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_actors['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_actors["preference"],
                  value: params[:actors]
                }
              }
            )
            session[:MLO_actors] = params[:actors]
          end
            
          if session[:MLO_directors] != params[:directors].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_directors['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_directors["preference"],
                  value: params[:directors]
                }
              }
            )
            session[:MLO_directors] = params[:directors]
          end
            
          if session[:MLO_raterun] != params[:raterun].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_rating_runtime['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_rating_runtime["preference"],
                  value: params[:raterun]
                }
              }
            )
            session[:MLO_raterun] = params[:raterun]
          end
            
            #if params[:actors]
            #session[:MLO_actors] = params[:actors]
            #puts "actors is #{session[:MLO_actors]}"
            #end
            #if params[:directors]
            #session[:MLO_directors] = params[:directors]
            #end
            #if params[:raterun]
            #session[:MLO_raterun] = params[:raterun]
            #end

        elsif params[:commitTLO] == "Update"

          if session[:TLO_address] != params[:address].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_address['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_address["preference"],
                  value: params[:address]
                }
              }
            )
            session[:TLO_address] = params[:address]
          end
            
          if session[:TLO_distance] != params[:distance].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_distance['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_distance["preference"],
                  value: params[:distance]
                }
              }
            )
            session[:TLO_distance] = params[:distance]
          end
            
          if session[:TLO_phone_number] != params[:phone_number].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_phone['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_phone["preference"],
                  value: params[:phone_number]
                }
              }
            )
            session[:TLO_phone_number] = params[:phone_number]
          end
            
            #if params[:address]
            #session[:TLO_address] = params[:address]
            #puts "address is #{session[:TLO_address]}"
            #end
            #if params[:phone_number]
            #session[:TLO_phone_number] = params[:phone_number]
            #puts "phone number is #{session[:TLO_phone_number]}"
            #end
            #if params[:distance]
            #session[:TLO_distance] = params[:distance]
            #end

        elsif params[:commitMO] == "Update"
          if session[:MO_liked_theatres] != params[:liked_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_liked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_liked_theatres["preference"],
                  value: params[:liked_theatres]
                }
              }
            )
            session[:MO_liked_theatres] = params[:liked_theatres]
          end
          
          if session[:MO_nearby_theatres] != params[:nearby_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_nearby_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_nearby_theatres["preference"],
                  value: params[:nearby_theatres]
                }
              }
            )
            session[:MO_nearby_theatres] = params[:nearby_theatres]
          end
            
          if session[:MO_disliked_theatres] != params[:disliked_theatres].to_s
            httpsarty.put("#{@user_preference_url}/#{@show_disliked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: session[:auth]
                },
                user_preference: {
                  preference: @show_disliked_theatres["preference"],
                  value: params[:disliked_theatres]
                }
              }
            )
            session[:MO_disliked_theatres] = params[:disliked_theatres]
          end
            
            #if params[:likedt]
            #session[:MO_likedt] = params[:likedt]
            #puts "liked teatres is #{session[:MO_likedt]}"
            #end
            #if params[:near]
            #session[:MO_near] = params[:near]
            #puts "nearby theatres is #{session[:MO_near]}"
            #end
            #if params[:dist]
            #session[:MO_dist] = params[:dist]
            #end      
        end
        @account =httpsarty.put("https://flavumovies.herokuapp.com/users.json", 
        body: {user: {auth_token: session[:auth]}}).parsed_response
        puts @account
            puts params[:commit1]
            puts params[:commit2]
      
      end
    end
  end #def
  def home
    require 'address'
    #@lat_lng = cookies[:lat_lng]
    #@lat_lng2 = @lat_lng.split('|')
    #puts @lat_lng2[0]

@ip = request.remote_ip
puts @ip
request.remote_ip
#@remote_ip = request.env["https_X_FORWARDED_FOR"]
#puts @remote_ip
UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      @i2=s.addr.last
    end
#puts @i2
    #puts @lat_lng
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      #@ip_address=open( "https://jsonip.com/" ){ |s| JSON::parse( s.string())['ip'] }
      #@ip_address = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
      #@ip_address=Address.get
      #real version
      @ip_address=@ip 
      #test version
      #@ip_address="184.70.5.250"
      
      @latlong=Geocoder.coordinates(@ip_address)

      #session[:latitude]=@latlong[0]
      #session[:longitude]=@latlong[1]
      #30.267447, -97.739513
      session[:latitude]="49.25"
      session[:longitude]="-123.1333"
      #@lat_lng2
      puts session[:latitude]
      puts session[:longitude]
      #puts @ip_address
      if session[:check_guest] == 'true'
        #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        #@nt=@theatres['nearby_theatres']
        puts session[:guest_auth]
        @url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        #puts @movies
        @rm=@movies['remaining_movies']
        @im=@movies['interested_movies']
        @nim=@movies['not_interested_movies']
        #session[:rm]=@movies['remaining_movies']
      else 

        @url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        @rm=@movies['remaining_movies']
        @im=@movies['interested_movies']
        @nim=@movies['not_interested_movies']
        #session[:rm]=@movies['remaining_movies']

      end

    end
  end

  def signout
    #reset_session 
    session[:check_guest] = "true"
    session[:auth] = nil

    redirect_to home_path
  end


  def cover
    #@guests =httpsarty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: 'true'}}).parsed_response 
    #@guests1 =httpsarty.get("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: "true"}}).parsed_response 
    #puts @guests1
    #puts @guests['auth_token']


  end

  def validate
    if (!flash[:notice])
      redirect_to cover_path
    else
    end
  end

  def showtimes
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end

      @url = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response

      #@theatres=JSON.parse(open("https://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@rm=@movies['remaining_movies']


      else
        #puts params[:liked]
       # puts params[:unliked]
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.post(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =httpsarty.delete(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end
      @url = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =httpsarty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
      #puts @theatres
      #@theatres=JSON.parse(open("https://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =httpsarty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =httpsarty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@rm=@movies['remaining_movies']

      end
    end
  end

  def showmovie

    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
        puts session[:check_guest]
        puts session[:auth]
        puts session[:guest_auth]
        puts params[:showid1]
        puts params[:showid2]
        puts params[:showid3]

        if session[:check_guest] == "true"
          if params[:showid]#should be movies in theatres page
            @id_showmovie = params[:showid]
            @url = "https://flavumovies.herokuapp.com/movies/#{params[:showid]}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
            @movies =httpsarty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
            @sm=@movies['movie']
          end
          @url2 = "https://flavumovies.herokuapp.com/theatres_for_movie/#{@id_showmovie}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @theatres_for_movie=httpsarty.get(@url2, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
      


        else
          if params[:showid]#should be movies in theatres page
            @id_showmovie = params[:showid]
            @url = "https://flavumovies.herokuapp.com/movies/#{params[:showid]}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
            @movies =httpsarty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
            @sm=@movies['movie']
          end
          @url2 = "https://flavumovies.herokuapp.com/theatres_for_movie/#{@id_showmovie}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @theatres_for_movie=httpsarty.get(@url2, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
      
        end
    end

  end

  def boxoffice
    @url = "https://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&apikey=ufqydfp3jtp9ytyr69j37835"
    @boxoffice =httpsarty.get(@url).parsed_response
    
  end

  def news
    @news =httpsarty.get("httpss://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=movie&rsz=8").parsed_response
    #@news['responseData']['results'].each do |news1|
      #@link1=news1['unescapedUrl']
    #end
    #@newsfeed="https://www.rollingstone.com/siteServices/rss/movieNewsAndFeature"
    #doc=Hpricot::XML(open(@newsfeed))
    #(doc/:channel/:item).each do |status|
    #  ['title'].each do |e1|
    #    @title= status.at(e1).inner_text
        
    #  end
    #end
  end

  def reviews
    #@url1 = "https://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&limit=20&apikey=ufqydfp3jtp9ytyr69j37835"
    #@boxoffice =httpsarty.get(@url1).parsed_response
    @url = "https://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @movies =httpsarty.get(@url, body: {user: {auth_token: session[:auth]  }, browser: "1"}).parsed_response
    @rm=@movies['remaining_movies']
    @im=@movies['interested_movies']
    @nim=@movies['not_interested_movies']


    #@url2 = "https://api.rottentomatoes.com/api/public/v1.0/movies/#{@movie_id}/reviews.json?review_type=top_cirtic&apikey=ufqydfp3jtp9ytyr69j37835"
    #@review =httpsarty.get(@url2).parsed_response
  end

  def showreview
    puts params[:review]
    puts params[:reviewid]
    @movie_id=params[:reviewid]
    @title=params[:review]
    @sr=params[:review].split(".").join(" ").split(":").join.split(" ")
    (0..@sr.length).each do |a2|
      if @sr[a2]=="&"
        @sr[a2]="and"
      end
    end
    @sr=@sr.join("+")
    #puts @sr
    @url2="https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=#{@sr}&api-key=a51160564ac0105b65bfd15f3ba6a454:7:67593218"
    @showreview=httpsarty.get(@url2).parsed_response
    puts @showreview
    #@link=@showreview['results'][0]['link']['url']
    #puts @link

    #@doc = Nokogiri::HTML(open(@link))
    #@i=@doc.css('.articleBody p').length
    #@i=@i-1
    #(0..@i).each do |j|
    #  puts @doc.css('.articleBody p')[j].content
    #end

    #@url2 = "https://api.rottentomatoes.com/api/public/v1.0/movies/#{params[:id]}/reviews.json?page_limit=1&apikey=ufqydfp3jtp9ytyr69j37835"
    #@reviews=httpsarty.get(@url2).parsed_response
    #puts @reviews
  end

  def confirm_account
    puts params[:confirmation_token]
    @url = "https://flavumovies.herokuapp.com/users/confirmation.json"
    @confirm_account =httpsarty.get(@url, body: {confirmation_token: params[:confirmation_token]}).parsed_response
    session[:auth]=@confirm_account['auth_token']   
    redirect_to home_path
  end

  def forgot_password
    if params[:confirm] =="confirm"
      puts params[:email]
      #puts params[:confirmation_token]
      @url = "https://flavumovies.herokuapp.com/users/password.json"
      @forgot_password =httpsarty.post(@url, body: {user: {email: params[:email]}})
      puts @forgot_password
    else
    
    end
  end

  def reset_password
    #puts params[:reset_password_token]
    #session[:reset_password_token] = params[:reset_password_token]
    #puts params[:reset_password_token]
      @password_reset_token=params[:reset_password_token]

    if params[:confirm]=="confirm"
      puts "yes"
      puts params[:password]
      puts params[:password_confirmation]       
      @url = "https://flavumovies.herokuapp.com/users/password.json"
      @password_reset_token =httpsarty.put(@url, body: { user: {reset_password_token: params[:reset_password], password: params[:password], password_confirmation: params[:password_confirmation] }}).parsed_response
      session[:auth]=@password_reset_token['auth_token']   
      puts @password_reset_token
      redirect_to home_path
    else

    end

  end

  def idevice
    @reset_password_token = params[:reset_password_token]
  end
end
