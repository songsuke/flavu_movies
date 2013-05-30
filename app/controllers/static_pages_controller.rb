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
      @users =HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
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
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      puts params[:confirm]
      if params[:confirm] !="confirm"
      else
        if (params[:password].length < 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        else
          @users_registations =HTTParty.put("http://flavumovies.herokuapp.com/users.json", body: {user: {auth_token: session[:guest_auth], password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email], guest: "false"}}).parsed_response
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
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      puts params[:confirm]
      if params[:confirm] !="confirm"
      else
        if (params[:password].length <= 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        else
          @users_registations =HTTParty.post("http://flavumovies.herokuapp.com/users.json", body: {user: {password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email]}}).parsed_response
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
            @liked_movies =HTTParty.post("http://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, interested_movie: { movie_id:params[:liked] ,interested: "true", not_interested: "false"}}).parsed_response
          elsif params[:unliked]
            @unliked_movies =HTTParty.post("http://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, not_interested_movie: { movie_id:params[:unliked] ,not_interested: "true", interested: "false"}}).parsed_response
          else
          end
          #puts params[:watched]
          if params[:watched]
            @watched_movies =HTTParty.post("http://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:watched] }}).parsed_response
          elsif params[:unwatched]
            @unwatched_movies =HTTParty.delete("http://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:unwatched]}}).parsed_response
          end
          if params[:showid]
            session[:showid] = params[:showid]
            redirect_to showmovie_path
          else
          end
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']

          #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          


        else
          #puts params[:liked]
          if params[:liked]
            @liked_movies =HTTParty.post("http://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:auth]}, interested_movie: { movie_id:params[:liked] ,interested: "true", not_interested: "false"}}).parsed_response
          elsif params[:unliked]
            @unliked_movies =HTTParty.post("http://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:auth]}, not_interested_movie: { movie_id:params[:unliked] ,not_interested: "true", interested: "false"}}).parsed_response
          else
          end
          #puts params[:watched]
          if params[:watched]
            @watched_movies =HTTParty.post("http://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:watched] }}).parsed_response
          elsif params[:unwatched]
            @unwatched_movies =HTTParty.delete("http://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: session[:auth]}, watched_movie: {movie_id:params[:unwatched]}}).parsed_response
          end

           if params[:showid]
            session[:showid] = params[:showid]
            redirect_to showmovie_path
          else
          end
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]  }, browser: "1"}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']
          #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
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
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end

      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response

      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@rm=@movies['remaining_movies']


      else
        #puts params[:liked]
       # puts params[:unliked]
        if params[:liked]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end
      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
      #puts @theatres
      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@rm=@movies['remaining_movies']

      end
    end
  end

  def showtheatre
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        if params[:showid1]
        session[:id_showtheatre] = params[:showid1]
        @id_showtheatre = session[:id_showtheatre].to_i
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        @st=@theatres['liked_theatres']
      elsif params[:showid2]
        session[:id_showtheatre] = params[:showid2]
        @id_showtheatre = session[:id_showtheatre].to_i
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        @st=@theatres['nearby_theatres']
      elsif params[:showid3]
        session[:id_showtheatre] = params[:showid3]
        @id_showtheatre = session[:id_showtheatre].to_i
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        @st=@theatres['not_interested_theatres']
      end

      
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@rm=@movies['remaining_movies']


      else
      #puts params[:showid]
      if params[:showid1]
        session[:id_showtheatre] = params[:showid1]
        @id_showtheatre = session[:id_showtheatre].to_i
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        @st=@theatres['liked_theatres']
      elsif params[:showid2]
        session[:id_showtheatre] = params[:showid2]
        @id_showtheatre = session[:id_showtheatre].to_i
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        @st=@theatres['nearby_theatres']
      elsif params[:showid3]
        session[:id_showtheatre] = params[:showid3]
        @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @id_showtheatre = session[:id_showtheatre].to_i
        @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        @st=@theatres['not_interested_theatres']
      end

      #@url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      #@theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}}).parsed_response

      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      #@lt=@theatres['liked_theatres']
      #@nt=@theatres['nearby_theatres']
      #@nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@rm=@movies['remaining_movies']

      end
    end

  end
  def buddies
    if (session[:auth])
    @a1=session[:auth]

    @url1 = "http://flavumovies.herokuapp.com/followers.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @followers =HTTParty.get(@url1, body: {user: {auth_token: @a1}}).parsed_response
    @url2 = "http://flavumovies.herokuapp.com/followees.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @followees =HTTParty.get(@url2, body: {user: {auth_token: @a1}}).parsed_response
    @url3 = "http://flavumovies.herokuapp.com/requests.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @requests =HTTParty.get(@url3, body: {user: {auth_token: @a1}}).parsed_response
    @url4 = "http://flavumovies.herokuapp.com/blockees.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @blockees =HTTParty.get(@url4, body: {user: {auth_token: @a1}}).parsed_response
    @url5 = "http://flavumovies.herokuapp.com/blockers.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @blockers =HTTParty.get(@url5, body: {user: {auth_token: @a1}}).parsed_response
    
    #showtime
      #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
      #@nt=@theatres['nearby_theatres']
      #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
      #@rm=@movies['remaining_movies']

  #  @followers=JSON.parse(open("http://flavumovies.herokuapp.com/followers.json?auth_token=kczrVERyuJu6RgevHZCx").read)
   # @followees=JSON.parse(open("http://flavumovies.herokuapp.com/followees.json?auth_token=kczrVERyuJu6RgevHZCx").read)
  #  @requests=JSON.parse(open("http://flavumovies.herokuapp.com/requests.json?auth_token=kczrVERyuJu6RgevHZCx").read)
  #  @blockees=JSON.parse(open("http://flavumovies.herokuapp.com/blockees.json?auth_token=kczrVERyuJu6RgevHZCx").read)
    @fw1=@followers['followers']
    @fw2=@followees['followees']
    @rq=@requests['friends_requests']
    @bk1=@blockees['blockees']
    @bk2=@blockers['blockers']

    @following =HTTParty.post("http://flavumovies.herokuapp.com/friendships/follow.json?id=#{params[:follow]}", body: {user: {auth_token: @a1}}).parsed_response
    @unfollowing =HTTParty.post("http://flavumovies.herokuapp.com/friendships/unfollow.json?id=#{params[:unfollow]}", body: {user: {auth_token: @a1}}).parsed_response
    @accept_and_follow =HTTParty.post("http://flavumovies.herokuapp.com/friendships/accept_and_follow.json?id=#{params[:accept_and_follow]}", body: {user: {auth_token: @a1}}).parsed_response
    @accept =HTTParty.post("http://flavumovies.herokuapp.com/friendships/accept.json?id=#{params[:accept]}", body: {user: {auth_token: @a1}}).parsed_response
    @reject =HTTParty.post("http://flavumovies.herokuapp.com/friendships/reject.json?id=#{params[:reject]}", body: {user: {auth_token: @a1}}).parsed_response
    @blocking =HTTParty.post("http://flavumovies.herokuapp.com/friendships/block.json?id=#{params[:block]}", body: {user: {auth_token: @a1}}).parsed_response
    #@unblocking =HTTParty.post("http://flavumovies.herokuapp.com/friendships/unblock.json?id=#{params[:unblock]}", body: {user: {auth_token: @a1}}).parsed_response
    @requesting =HTTParty.post("http://flavumovies.herokuapp.com/send_request.json", body: {user: {auth_token: @a1}, friend_contact_info:params[:friend_contact_info]}).parsed_response
    #HTTParty.post("http://flavumovies.herokuapp.com/send_request.json", body: {user: {auth_token: "pb3BiqsJkvxbv2P3jnTR", friend_contact_info:"user1"}}).parsed_response
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
        @url1 = "http://flavumovies.herokuapp.com/genre_preferences.json"
        @url2 = "http://flavumovies.herokuapp.com/director_preferences.json"
        @url3 = "http://flavumovies.herokuapp.com/actor_preferences.json"
        @genre_preferences =HTTParty.get(@url1, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @director_preferences =HTTParty.get(@url2, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @actor_preferences =HTTParty.get(@url3, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        

        @url4 = "http://flavumovies.herokuapp.com/genres.json"
        @all_genres =HTTParty.get(@url4, body: {user: {auth_token: session[:guest_auth]}}).parsed_response

        @genre_update =HTTParty.put("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre] ,score: params[:score]}}).parsed_response
        puts @x1
        puts params[:score]
        puts params[:genre]

        @genre_create =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
     
        @genre_delete =HTTParty.delete("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:guest_auth]}, genre_preference: {genre: params[:genre_delete] ,score: params[:score]}}).parsed_response
        puts params[:genre_delete]
        
        
        #@genre_update =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", 
        #  body: {user: {auth_token: @a1}, genre_preference: {genre: params[:genre],score: params[:score]}}).parsed_response


       #@genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
      # @director_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/director_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
       #@actor_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/actor_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']
        
        #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      else
        ##puts params[:score]
        #@a1=session[:auth]
        #puts session[:auth]
        puts "update = #{params[:update]}"
        puts "update1 =#{params[:genre_update]}"
        puts "delete= #{params[:delete]}"
        puts "create2=#{params[:create2]}"
        puts params[:director_create]
        if params[:create1] == "Create"
          @genre_create =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update] =="Update"
          @genre_update =HTTParty.put("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete] == "Delete"
          @genre_delete =HTTParty.delete("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create2] == "Create"
          @director_create =HTTParty.post("http://flavumovies.herokuapp.com/director_preferences.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update2] =="Update"
          @director_update =HTTParty.put("http://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete2] == "Delete"
          @director_delete =HTTParty.delete("http://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: session[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create3] == "Create"
          @actor_create =HTTParty.post("http://flavumovies.herokuapp.com/actor_preferences.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update3] =="Update"
          @actor_update =HTTParty.put("http://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete3] == "Delete"
          @actor_delete =HTTParty.delete("http://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: session[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response

        end
        @url1 = "http://flavumovies.herokuapp.com/genre_preferences.json"
        @url2 = "http://flavumovies.herokuapp.com/director_preferences.json"
        @url3 = "http://flavumovies.herokuapp.com/actor_preferences.json"
        @genre_preferences =HTTParty.get(@url1, body: {user: {auth_token: session[:auth]}}).parsed_response
        @director_preferences =HTTParty.get(@url2, body: {user: {auth_token: session[:auth]}}).parsed_response
        @actor_preferences =HTTParty.get(@url3, body: {user: {auth_token: session[:auth]}}).parsed_response
        

        @url4 = "http://flavumovies.herokuapp.com/genres.json"
        @all_genres =HTTParty.get(@url4, body: {user: {auth_token: session[:auth]}}).parsed_response
        @url5 = "http://flavumovies.herokuapp.com/directors.json"
        @all_directors =HTTParty.get(@url5, body: {user: {auth_token: session[:auth]}}).parsed_response
        @url6 = "http://flavumovies.herokuapp.com/actors.json"
        @all_actors =HTTParty.get(@url6, body: {user: {auth_token: session[:auth]}}).parsed_response
       
        #@directors=@all_directors['movie_directors']
       # puts @x1
       # puts params[:score]
       # puts params[:genre]
   
       # puts params[:genre_delete]
      
      
      #@genre_update =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", 
      #  body: {user: {auth_token: @session[:auth]}, genre_preference: {genre: params[:genre],score: params[:score]}}).parsed_response


        #puts session[:auth]
     #@genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
    # @director_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/director_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
     #@actor_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/actor_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']

        #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@rm=@movies['remaining_movies']

      end
    end
  
  end
  def edit
    reset_session
    redirect_to cover_path
    
    
  end
  def settings 
    

    if (session[:auth])
      #@a1=session[:auth]
      @user=session[:user]
     # puts session[:auth]
     # puts @a1
     
      if params[:commit1] == "Update"
        @setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
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
        #@setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
        #body: {user: {auth_token: session[:auth], username: params[:username]}}).parsed_response
        #if (@setting_account['errors'])
          #flash[:error] = "Update username is error. Please try again"
          #flash[:notice] = nil
        #else
          #flash[:notice] = "Update your username is successful"   
          #flash[:error] = nil  
        #end

      #elsif params[:commit3] == "Update"
        #@setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
        #body: {user: {auth_token: session[:auth], display_name: params[:display_name]}}).parsed_response
        #flash[:notice] = "Update your display name is successful"
        #flash[:notice] = nil

      #elsif params[:commit4] == "Update"
        #@setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
        #body: {user: {auth_token: session[:auth], phone_number: params[:phone_number]}}).parsed_response
        #if (@setting_account['errors'])
          #flash[:error] = "Your phone number has something wrong. Please try again" 
          #flash[:notice] = nil
        #else
          #flash[:notice] = "Update your phone number is successful"
          #flash[:error] = nil
        #end

      #elsif params[:commit5] == "Update"
        #@setting_account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
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
        @user_preference =HTTParty.get("http://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @a1}}).parsed_response
        @radius_id = @user_preference['user_preferences'].third['id'].to_i
        @unit_id = @user_preference['user_preferences'].last['id'].to_i
        puts @radius_id
        puts @unit_id
        @radius2 =HTTParty.put("http://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json", 
          body: {
          user: {auth_token: session[:auth]} ,
          user_preference: {preference: "search radius", value: params[:radius]} 
          }).parsed_response      
        @unit2 =HTTParty.put("http://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json", 
          body: {
          user: {auth_token: session[:auth]} ,
          user_preference: {preference: "unit of measure", value: params[:unit]} 
          }).parsed_response  

      elsif params[:commitMLO] == "Update"

        if params[:genres]
          session[:MLO_genres] = params[:genres]
          puts "genres is #{session[:MLO_genres]}"
        end
        if params[:actors]
          session[:MLO_actors] = params[:actors]
          puts "actors is #{session[:MLO_actors]}"
        end
        if params[:directors]
          session[:MLO_directors] = params[:directors]
        end
        if params[:raterun]
          session[:MLO_raterun] = params[:raterun]
        end

      elsif params[:commitTLO] == "Update"

        if params[:address]
          session[:TLO_address] = params[:address]
          puts "address is #{session[:TLO_address]}"
        end
        if params[:phone_number]
          session[:TLO_phone_number] = params[:phone_number]
          puts "phone number is #{session[:TLO_phone_number]}"
        end
        if params[:distance]
          session[:TLO_distance] = params[:distance]
        end

      elsif params[:commitMO] == "Update"

        if params[:likedt]
          session[:MO_likedt] = params[:likedt]
          puts "liked teatres is #{session[:MO_likedt]}"
        end
        if params[:near]
          session[:MO_near] = params[:near]
          puts "nearby theatres is #{session[:MO_near]}"
        end
        if params[:dist]
          session[:MO_dist] = params[:dist]
        end

      end


      @account =HTTParty.put("http://flavumovies.herokuapp.com/users.json", 
      body: {user: {auth_token: session[:auth]}}).parsed_response
      @user_preference =HTTParty.get("http://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: session[:auth]}}).parsed_response
      #@radius_id = @user_preference['user_preferences'].third['id'].to_i
      #@unit_id = @user_preference['user_preferences'].last['id'].to_i
      #puts @radius_id
      #puts @unit_id
     #puts @account
      #@radius =HTTParty.get("http://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json", body: {user: {auth_token: session[:auth]}}).parsed_response
      #puts @user_preference7 #['user_preference']['value']
      #@unit =HTTParty.get("http://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json", body: {user: {auth_token: session[:auth]}}).parsed_response

      
        #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
          #@rm=@movies['remaining_movies']
          puts params[:commit1]
          puts params[:commit2]
    else
      redirect_to home_path
    end

  end

  def home
    require 'address'
    #@lat_lng = cookies[:lat_lng]
    #@lat_lng2 = @lat_lng.split('|')
    #puts @lat_lng2[0]

@ip = request.remote_ip
puts @ip
request.remote_ip
#@remote_ip = request.env["HTTP_X_FORWARDED_FOR"]
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
      #@ip_address=open( "http://jsonip.com/" ){ |s| JSON::parse( s.string())['ip'] }
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
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        #@nt=@theatres['nearby_theatres']
        puts session[:guest_auth]
        @url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
        #puts @movies
        @rm=@movies['remaining_movies']
        @im=@movies['interested_movies']
        @nim=@movies['not_interested_movies']
        #session[:rm]=@movies['remaining_movies']
      else 

        #for showtimes
        #@showtimes=[]
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@nearby_theatres = @theatres['nearby_theatres']['theatres']
        #@nearby_theatres.each do |nearby_theatre|
        #  nearby_theatre['movies'].each do |movie|
        #    movie['showtimes'].each do |showtime|
        #      showtime['theatre_id'] = nearby_theatre['id']
        #      showtime['movie_id'] = movie['id']
        #      @showtimes << showtime
        #    end
        #  end
        #end
        #s=@showtimes.select{|st| st['movie_id']=99}
        #puts @showtimes
        #session[:showtimes] = @showtimes

        @url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
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
    #@guests =HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: 'true'}}).parsed_response 
    #@guests1 =HTTParty.get("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: "true"}}).parsed_response 
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
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:guest_auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end

      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response

      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        #@rm=@movies['remaining_movies']


      else
        #puts params[:liked]
       # puts params[:unliked]
        if params[:liked]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
        elsif params[:unliked]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
        elsif params[:soso1]
          @url = "http://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
        elsif params[:soso2]
          @url = "http://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: session[:auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response

        end
      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
      #puts @theatres
      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      #showtime
        #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@nt=@theatres['nearby_theatres']
        #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        #@rm=@movies['remaining_movies']

      end
    end
  end

  def showmovie

    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
        #@a1=session[:auth]
        puts session[:check_guest]
        puts session[:auth]
        puts session[:guest_auth]
        puts params[:showid1]
        puts params[:showid2]
        puts params[:showid3]
        #session[:showid] = params[:showid]
        #@id_showmovie=session[:showid].to_i
        if session[:check_guest] == "true"
          if params[:showid1]
          session[:showid1] = params[:showid1]
          @id_showmovie=session[:showid1].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          @sm=@movies['interested_movies']

          elsif params[:showid2]
          session[:showid2] = params[:showid2]
          @id_showmovie=session[:showid2].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          #puts @movies
          @sm=@movies['remaining_movies']
          @sm['movies'].each do |a1|
            if a1['id'] == @id_showmovie 
              @title = a1['title']
              #puts @title
            end
          end

          #@embed_code = TrailerAddict.get_trailer_embed_code("#{@title}")
          #@trailers = @embed_code.split
          #@trailers[1]="width=\"640\""
          #@trailers[2]="height=\"360\"><param"
          #@trailers[16]="width=\"640\""
          #@trailers[17]="height=\"360\"></embed></object>"
          #@trailers=@trailers.join(" ")
          #puts @embed_code
          #puts @trailers
          @title1=@title.split("3D").join.split(".").join.split(":").join.split(" ")
          puts @title1
          (0..@title1.length).each do |a2|
            if @title1[a2]=="&"
              @title1[a2]="and"
            end
          end
          @title1=@title1.join("-")
          puts @title1
          @trailer_url="http://api.traileraddict.com/?film=#{@title1}&width=640"
          doc=Hpricot::XML(open(@trailer_url))
          (doc/:trailers/:trailer).each do |status|
            ['embed'].each do |e1|
              #puts "status#{status.at(e1).inner_text}"
              @trailers= status.at(e1).inner_text
            end
          end

          elsif params[:showid3]
          session[:showid3] = params[:showid3]
          @id_showmovie=session[:showid3].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          @sm=@movies['not_interested_movies']

          elsif params[:showid]#should be movies in theatres page
          session[:showid] = params[:showid]
          @id_showmovie=session[:showid].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          @sm=@movies['remaining_movies']
          end

          @url2 = "http://flavumovies.herokuapp.com/theatres_for_movie/#{@id_showmovie}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @theatres_for_movie=HTTParty.get(@url2, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
         
          #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}, browser: "1"}).parsed_response
          #@rm=@movies['remaining_movies']
        


        else
          if params[:showid1]
          session[:showid1] = params[:showid1]
          @id_showmovie=session[:showid1].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          @sm=@movies['interested_movies']

          elsif params[:showid2]
          session[:showid2] = params[:showid2]
          @id_showmovie=session[:showid2].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #puts @movies
          @sm=@movies['remaining_movies']
          #@sm['movies'].each do |a1|
          #  if a1['id'] == @id_showmovie 
          #    @title = a1['title']
              #puts @title
          #  end
          #end
          #@title1=@title.split("3D").join.split(".").join.split(" ")
          #puts @title1
          #(0..@title1.length).each do |a2|
          #  if @title1[a2]=="&"
          #    @title1[a2]="and"
          #  end
          #end

          #@title1=@title1.join("-")
          
          puts @title1
          @trailer_url="http://api.traileraddict.com/?film=#{@title1}&width=640"
          doc=Hpricot::XML(open(@trailer_url))
          (doc/:trailers/:trailer).each do |status|
            ['embed'].each do |e1|
              #puts "status#{status.at(e1).inner_text}"
              @trailer= status.at(e1).inner_text
            end
          end

          elsif params[:showid3]
          session[:showid3] = params[:showid3]
          @id_showmovie=session[:showid3].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          @sm=@movies['not_interested_movies']

          elsif params[:showid]#should be movies in theatres page
          session[:showid] = params[:showid]
          @id_showmovie=session[:showid].to_i
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          @sm=@movies['remaining_movies']
          #@sm['movies'].each do |a1|
          #  if a1['id'] == @id_showmovie 
          #    @title = a1['title']
              #puts @title
          #  end
          #end
          #@title1=@title.split(" ").join("-")
          #puts @title1
          #@trailer_url="http://api.traileraddict.com/?film=#{@title1}&width=640"
          #doc=Hpricot::XML(open(@trailer_url))
          #(doc/:trailers/:trailer).each do |status|
          #  ['embed'].each do |e1|
              #puts "status#{status.at(e1).inner_text}"
          #    @trailer= status.at(e1).inner_text
          #  end
          #end
          end
          @url2 = "http://flavumovies.herokuapp.com/theatres_for_movie/#{@id_showmovie}.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @theatres_for_movie=HTTParty.get(@url2, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #puts @theatres_for_movie
          
          #showtime
          #@url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #@nt=@theatres['nearby_theatres']
          #@url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          #@movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}, browser: "1"}).parsed_response
          #@rm=@movies['remaining_movies']
      
        end

      #puts params[:liked]
      #puts @liked_movies
    end

  end

  def boxoffice
    @url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&apikey=ufqydfp3jtp9ytyr69j37835"
    @boxoffice =HTTParty.get(@url).parsed_response
    
  end

  def news
    @news =HTTParty.get("https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=movie&rsz=8").parsed_response
    #@news['responseData']['results'].each do |news1|
      #@link1=news1['unescapedUrl']
    #end
    #@newsfeed="http://www.rollingstone.com/siteServices/rss/movieNewsAndFeature"
    #doc=Hpricot::XML(open(@newsfeed))
    #(doc/:channel/:item).each do |status|
    #  ['title'].each do |e1|
    #    @title= status.at(e1).inner_text
        
    #  end
    #end
  end

  def reviews
    #@url1 = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&limit=20&apikey=ufqydfp3jtp9ytyr69j37835"
    #@boxoffice =HTTParty.get(@url1).parsed_response
    @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
    @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]  }, browser: "1"}).parsed_response
    @rm=@movies['remaining_movies']
    @im=@movies['interested_movies']
    @nim=@movies['not_interested_movies']


    #@url2 = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{@movie_id}/reviews.json?review_type=top_cirtic&apikey=ufqydfp3jtp9ytyr69j37835"
    #@review =HTTParty.get(@url2).parsed_response
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
    @url2="http://api.nytimes.com/svc/movies/v2/reviews/search.json?query=#{@sr}&api-key=a51160564ac0105b65bfd15f3ba6a454:7:67593218"
    @showreview=HTTParty.get(@url2).parsed_response
    puts @showreview
    #@link=@showreview['results'][0]['link']['url']
    #puts @link

    #@doc = Nokogiri::HTML(open(@link))
    #@i=@doc.css('.articleBody p').length
    #@i=@i-1
    #(0..@i).each do |j|
    #  puts @doc.css('.articleBody p')[j].content
    #end

    #@url2 = "http://api.rottentomatoes.com/api/public/v1.0/movies/#{params[:id]}/reviews.json?page_limit=1&apikey=ufqydfp3jtp9ytyr69j37835"
    #@reviews=HTTParty.get(@url2).parsed_response
    #puts @reviews
  end

  def confirm_account
    puts params[:confirmation_token]
    @url = "http://flavumovies.herokuapp.com/users/confirmation.json"
    @confirm_account =HTTParty.get(@url, body: {confirmation_token: params[:confirmation_token]}).parsed_response
    session[:auth]=@confirm_account['auth_token']   
    redirect_to home_path
  end

  def forgot_password
    if params[:confirm] =="confirm"
      puts params[:email]
      #puts params[:confirmation_token]
      @url = "http://flavumovies.herokuapp.com/users/password.json"
      @forgot_password =HTTParty.post(@url, body: {user: {email: params[:email]}})
      puts @forgot_password
    else
    
    end
  end

  def request_password_recovery
    puts params[:email]
    puts params[:confirmation_token]
    @url = "http://flavumovies.herokuapp.com/users/confirmation.json"
    @confirm_account =HTTParty.get(@url, body: {confirmation_token: params[:confirmation_token]}).parsed_response
    session[:auth]=@confirm_account['auth_token']   
    redirect_to home_path
  end

  def reset_password
    #params[:reset_password_token]
    #puts params[:reset_password_token]
    puts params[:confirm]
    if params[:confirm]=="confirm"
      @url = "http://flavumovies.herokuapp.com/users/password.json"
      @reset_password =HTTParty.put(@url, body: { user:{reset_password_token: params[:reset_password_token], password: params[:password], password_confirmation: params[:password_confirmation] }}).parsed_response
      session[:auth]=@reset_password['auth_token']   
      puts @reset_password
      redirect_to home_path
    else

    end

  end


end
