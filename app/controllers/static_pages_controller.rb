class StaticPagesController < ApplicationController
require 'httparty'
require 'open-uri'
before_filter :authenticate_user, :except => [:signin, :register, :facebook,:idevice]


  def signin
    #Check if the button is clicked
    if params[:confirm] !="confirm"
    else
      puts "my param #{params[:login]}"
      #Send Parameters Username(EMail) and Password to the API
      @users =HTTParty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
      #If there's an error, shows the error
      if (@users.first[0]=="error")
        flash[:error] = "Username or Password is wrong. Please try again"
      else
      #If the remember me button is checked, the login will be permanent by using cookies until users log out by themselves
        if params[:checkbox]['check']=="1"
          cookies.permanent.signed[:auth] = {value: "#{@users['auth_token']}"}
          cookies.permanent.signed[:username] = {value: "#{@users['username']}"}
          cookies.permanent.signed[:user_id] = {value: "#{@users['id']}"}
          cookies.permanent.signed[:user] = {value: "#{@users}"}
      #If the remember me button is not checked, the login will be tempopary when users close the tab, it'll be logged out by the system 
        elsif params[:checkbox]['check']=="0"
          cookies.signed[:auth] = {value: "#{@users['auth_token']}"}
          cookies.signed[:username] = {value: "#{@users['username']}"}
          cookies.signed[:user_id] = {value: "#{@users['id']}"}
          cookies.signed[:user] = {value: "#{@users}"}
        end
        #cookies.signed[:auth] ={secure: true, httponly: true, domain: 'flavu.com', value: "#{@auth_token}"}
        #cookies.signed[:latitude] = '49.28385281'
       # cookies.signed[:longitude] = '-123.1120815'
        #@username=cookies.signed[:username]
        #@auth=cookies.signed[:auth]
        #Cookies check guest is to distiguish between a guest or a member 
        cookies.permanent.signed[:check_guest] = {value: "false"}
        redirect_to root_path
      end
    end
  end

  def register
    #If a user enters as a guest, this code will register the user to be a guest member
    if cookies.signed[:check_guest] == 'true'
      if params[:confirm] !="confirm"
      else
        if (params[:password].length < 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        else
          @users_registations =HTTParty.put("https://flavumovies.herokuapp.com/users.json", body: {user: {auth_token: cookies.signed[:guest_auth], password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email], guest: "false"}}).parsed_response
          if (@users_registations['errors'])
            @check_register='false'
            flash[:error] = "#{params[:email]} has already been taken. Please try again"
          else
            flash[:notice] = "Register is successful. Please check you email."
            redirect_to validate_path
          end
        end
      end
    # A user registers to the API      
    else
      if params[:confirm] !="confirm"
      else
        #Password has to be more than 6 characters
        if (params[:password].length <= 6)
          flash[:error] = "Your password is too short. It has to be more than 6 characters"
        #match email
        elsif params[:email] != params[:email_confirmation]
          flash[:error] = "Your email does not match. Please try again" 
        #Send parameters for registration
        else
          @users_registations =HTTParty.post("https://flavumovies.herokuapp.com/users.json", body: {user: {password: params[:password], password_confirmation: params[:password], email: params[:email], username: params[:email], display_name: params[:email]}}).parsed_response
          if (@users_registations['errors'])
            @check_register='false'
            flash[:error] = "#{params[:email]} has already been taken. Please try again"
          else
            flash[:notice] = "Register is successful. Please check your email."
            redirect_to validate_path
          end
        end
      end
    end


  end

  def movies
    #@layout_type is for main menu
    #@lat_lng = cookies[:lat_lng]
    #@lat_lng2 = @lat_lng.split('|')
    #puts @lat_lng2[0]
        puts "auth#{cookies.signed[:auth]}"
        puts "guest#{cookies.signed[:guest_auth]}"
@ip = request.remote_ip
puts @ip
request.remote_ip
#@remote_ip = request.env["https_X_FORWARDED_FOR"]
#puts @remote_ip
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      @i2=s.addr.last
    end
      #@ip_address=open( "https://jsonip.com/" ){ |s| JSON::parse( s.string())['ip'] }
      #@ip_address = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
      #@ip_address=Address.get
      #real version
      @ip_address=@ip 
      #test version
      #@ip_address="184.70.5.250"
      
      @latlong=Geocoder.coordinates(@ip_address)

      #cookies.signed[:latitude]=@latlong[0]
      #cookies.signed[:longitude]=@latlong[1]
      #30.267447, -97.739513
      cookies.permanent.signed[:latitude]="49.25"
      cookies.permanent.signed[:longitude]="-123.1333"

    @layout_type = "movies"
    if (!cookies.signed[:auth]) && (!cookies.signed[:guest_auth])
      redirect_to cover_path
    else
      #To distiguish guest or user
      if (cookies.signed[:check_guest] == 'true')
          @token=cookies.signed[:guest_auth]        
      else 
          @token=cookies.signed[:auth] 
      end

      #IF users change radius and unit on the settings page, they will be kept in cookies for performance reasons
      if (cookies.signed[:SO_radius]) && (cookies.signed[:SO_unit])
        cookies.signed[:radius]=cookies.signed[:SO_radius]
        cookies.signed[:unit]=cookies.signed[:SO_unit] 
      end
      if (cookies.signed[:radius]) && (cookies.signed[:unit])
      else  
      #so if users don't change on the settings page, they will be loaded onto this page
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @token}}).parsed_response
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        cookies.signed[:radius]=@radius
        cookies.signed[:unit]=@unit
      end
      #liked,unliked and so on buttons  
      if params[:liked]
        @liked_movies =HTTParty.post("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: @token}, interested_movie: { movie_id:params[:liked]}}).parsed_response
      elsif params[:unliked]
        @unliked_movies =HTTParty.post("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: @token}, not_interested_movie: { movie_id:params[:unliked]}}).parsed_response
      elsif params[:soso1]
        @soso_movies =HTTParty.delete("https://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: @token}, interested_movie: { movie_id:params[:soso1]}}).parsed_response
      elsif params[:soso2]
        @soso_movies =HTTParty.delete("https://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: @token}, not_interested_movie: { movie_id:params[:soso2]}}).parsed_response
      end
       #watched and unwatched buttons 
      if params[:watched]
        @watched_movies =HTTParty.post("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: @token}, watched_movie: {movie_id:params[:watched] }}).parsed_response
      elsif params[:unwatched]
        @unwatched_movies =HTTParty.delete("https://flavumovies.herokuapp.com/watched_movies.json", body: {user: {auth_token: @token}, watched_movie: {movie_id:params[:unwatched]}}).parsed_response
      end
      
      #fetch data from API
      @url = "https://flavumovies.herokuapp.com/movies_browser.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}&radius=#{cookies.signed[:radius]}&unit=#{cookies.signed[:unit]}"
      @movies = HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
      #check token
      if !token_valid?(@movies)
        redirect_to signin_path
        return
      end
      #set parameters to use on the view page
      @rm = @movies['remaining_movies']
      @im = @movies['interested_movies']
      @nim = @movies['not_interested_movies']
 
    end
  end

  def theatres
    #@layout_type is for main menu
    #the code on theatres controller is the same concept, the difference is just the URL of the API
    @layout_type = "theatres"
    if (!cookies.signed[:auth] && !cookies.signed[:guest_auth])
      redirect_to cover_path
    else

      if (cookies.signed[:check_guest] == 'true')
          @token=cookies.signed[:guest_auth]        
      else 
          @token=cookies.signed[:auth] 
      end

      #get_radius and unit
      if (cookies.signed[:SO_radius]) && (cookies.signed[:SO_unit])
        cookies.signed[:radius]=cookies.signed[:SO_radius]
        cookies.signed[:unit]=cookies.signed[:SO_unit] 
      end
      if (cookies.signed[:radius]) && (cookies.signed[:unit])
      else 
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @token}}).parsed_response
        if !token_valid?(@user_preference)
          redirect_to signin_path
          return
        end
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        cookies.signed[:radius]=@radius
        cookies.signed[:unit]=@unit
      end
        
        
      if params[:liked]
        @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
        @theatres =HTTParty.post(@url, body: {user: {auth_token: @token}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
      elsif params[:unliked]
        @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
        @theatres =HTTParty.post(@url, body: {user: {auth_token: @token}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
      elsif params[:soso1]
        @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
        @theatres =HTTParty.delete(@url, body: {user: {auth_token: @token}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
      elsif params[:soso2]
        @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
        @theatres =HTTParty.delete(@url, body: {user: {auth_token: @token}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response
      end
        
      @url = "https://flavumovies.herokuapp.com/theatres_ios.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}&radius=#{cookies.signed[:radius]}&unit=#{cookies.signed[:unit]}"
      @theatres = HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
      if !token_valid?(@theatres)
        redirect_to signin_path
        return
      end
      puts @theatres
      @lt = @theatres['liked_theatres']
      @nt = @theatres['nearby_theatres']
      @nit = @theatres['not_interested_theatres']
    end
  end

  def showtheatre
    
    if (!cookies.signed[:auth]) && (!cookies.signed[:guest_auth])
      redirect_to cover_path
    else
      #check latitude and longitude if they're from the actual code(there're test and actual ones)
      if cookies[:lat_lng]
        @lat_lng = cookies[:lat_lng].split("|")
      end
      #this page will recieve a parameter from theatre page
      @url = "https://flavumovies.herokuapp.com/theatres/#{params[:showid]}.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}"     
      if cookies.signed[:check_guest] == "true"
        @token=cookies.signed[:guest_auth]
      else
        @token=cookies.signed[:auth]
      end
      @theatres =HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
      if !token_valid?(@theatres)
        redirect_to signin_path
        return
      end
      @st=@theatres['theatre']
    end
  end

  def buddies

    @layout_type = "buddies"
    if (cookies.signed[:auth])
      #send a request
      if params[:request]
        @requesting =HTTParty.post("https://flavumovies.herokuapp.com/send_request.json", body: {user: {auth_token: cookies.signed[:auth]}, friend_contact_info: params[:request]}).parsed_response
        if !token_valid?(@requesting)
          redirect_to signin_path
          return
        end
        #follow users
      elsif params[:follow]
        @follow =HTTParty.post("https://flavumovies.herokuapp.com/friendships/follow.json?id=#{params[:follow]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        if !token_valid?(@follow)
          redirect_to signin_path
          return
        end
        #unfollow one of your movies buddies, the status will become friends
      elsif params[:unfollow]
        @unfollow =HTTParty.post("https://flavumovies.herokuapp.com/friendships/unfollow.json?id=#{params[:unfollow]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response    
        if !token_valid?(@unfollow)
          redirect_to signin_path
          return
        end
        #accept and follow, the status will become movie buddies
      elsif params[:accept_and_follow]
        @accept_and_follow =HTTParty.post("https://flavumovies.herokuapp.com/friendships/accept_and_follow.json?id=#{params[:accept_and_follow]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        if !token_valid?(@accept_and_follow)
          redirect_to signin_path
          return
        end
        #just accept people to follow you
      elsif params[:accept]
        @accept =HTTParty.post("https://flavumovies.herokuapp.com/friendships/accept.json?id=#{params[:accept]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        if !token_valid?(@accept)
          redirect_to signin_path
          return
        end
        #reject requests
      elsif params[:reject]
        @reject =HTTParty.post("https://flavumovies.herokuapp.com/friendships/reject.json?id=#{params[:reject]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        if !token_valid?(@reject)
          redirect_to signin_path
          return
        end
      #elsif params[:block]
        #@block =HTTParty.post("https://flavumovies.herokuapp.com/friendships/block.json?id=#{params[:block]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
      #elsif params[:unblock]
        #@unblock =HTTParty.post("https://flavumovies.herokuapp.com/friendships/unblock.json?id=#{params[:unblock]}", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        #puts @unblock
      end

      #fetch data from the API
      @url1 = "https://flavumovies.herokuapp.com/followers.json"
      @followers =HTTParty.get(@url1, body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
      if !token_valid?(@followers)
        redirect_to signin_path
        return
      end
      @url2 = "https://flavumovies.herokuapp.com/followees.json"
      @followees =HTTParty.get(@url2, body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
      if !token_valid?(@followees)
        redirect_to signin_path
        return
      end
      @url3 = "https://flavumovies.herokuapp.com/requests.json"
      @requests =HTTParty.get(@url3, body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
      if !token_valid?(@requests)
        redirect_to signin_path
        return
      end
      #@url4 = "https://flavumovies.herokuapp.com/blockees.json"
      #@blockees =HTTParty.get(@url4, body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
      #puts params[:reject]
      @fw1=@followers['followers']
      @fw2=@followees['followees']
      @rq=@requests['friends_requests']
      #puts @fw2

      #@bk1=@blockees['blockees']
      #@bk2=@blockers['blockers']
    else
    end
  end

  def preferences

    @layout_type = "preferences"
    if (!cookies.signed[:auth] && !cookies.signed[:guest_auth])
      redirect_to cover_path
    else
      #for guest member activities
      if cookies.signed[:check_guest] == 'true'
        @token=cookies.signed[:guest_auth]
        if params[:create1] == "Create"
          @genre_create =HTTParty.post("https://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update] =="Update"
          @genre_update =HTTParty.put("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete] == "Delete"
          @genre_delete =HTTParty.delete("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create2] == "Create"
          @director_create =HTTParty.post("https://flavumovies.herokuapp.com/director_preferences.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, director_preference: {director: params[:director_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update2] =="Update"
          @director_update =HTTParty.put("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete2] == "Delete"
          @director_delete =HTTParty.delete("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:create3] == "Create"
          @actor_create =HTTParty.post("https://flavumovies.herokuapp.com/actor_preferences.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, actor_preference: {actor: params[:actor_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update3] =="Update"
          @actor_update =HTTParty.put("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete3] == "Delete"
          @actor_delete =HTTParty.delete("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: cookies.signed[:guest_auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        end

        #for flavu member activities
      else
        @token=cookies.signed[:auth]
        if params[:create1] == "Create"
          @genre_create =HTTParty.post("https://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: cookies.signed[:auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update] =="Update"
          @genre_update =HTTParty.put("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete] == "Delete"
          @genre_delete =HTTParty.delete("https://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, genre_preference: {genre: params[:genre_update] ,score: params[:score]}}).parsed_response

        elsif params[:create2] == "Create"
          @director_create =HTTParty.post("https://flavumovies.herokuapp.com/director_preferences.json", body: {user: {auth_token: cookies.signed[:auth]}, director_preference: {director: params[:director_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update2] =="Update"
          @director_update =HTTParty.put("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete2] == "Delete"
          @director_delete =HTTParty.delete("https://flavumovies.herokuapp.com/director_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, director_preference: {director: params[:director_update] ,score: params[:score]}}).parsed_response
          puts @director_delete
        elsif params[:create3] == "Create"
          @actor_create =HTTParty.post("https://flavumovies.herokuapp.com/actor_preferences.json", body: {user: {auth_token: cookies.signed[:auth]}, actor_preference: {actor: params[:actor_create] ,score: params[:score]}}).parsed_response
        
        elsif params[:update3] =="Update"
          @actor_update =HTTParty.put("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        
        elsif params[:delete3] == "Delete"
          @actor_delete =HTTParty.delete("https://flavumovies.herokuapp.com/actor_preferences/1.json", body: {user: {auth_token: cookies.signed[:auth]}, actor_preference: {actor: params[:actor_update] ,score: params[:score]}}).parsed_response
        end
         

      end
      if params[:taste] =="taste"
        puts "Tye"
        puts params[:taste]
@url_search="https://flavumovies.herokuapp.com/genre_preferences.json"
        @taste_search = HTTParty.get(@url_search, body: {user: {auth_token: @token, search: params[:taste]}}).parsed_response
      end
      @url1 = "https://flavumovies.herokuapp.com/genre_preferences.json"
      @url2 = "https://flavumovies.herokuapp.com/director_preferences.json"
      @url3 = "https://flavumovies.herokuapp.com/actor_preferences.json"
      @genre_preferences =HTTParty.get(@url1, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@genre_preferences)
        redirect_to signin_path
        return
      end
      @director_preferences =HTTParty.get(@url2, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@director_preferences)
        redirect_to signin_path
        return
      end
      @actor_preferences =HTTParty.get(@url3, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@actor_preferences)
        redirect_to signin_path
        return
      end

      @gp=@genre_preferences['genre_preferences']
      @dp=@director_preferences['director_preferences']
      @ap=@actor_preferences['actor_preferences']
      @api_key = "fe9909ee5e73ffa4e62bd0fdc584b4bb"


=begin
@url4 = "https://flavumovies.herokuapp.com/genres.json"
      @all_genres =HTTParty.get(@url4, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@all_genres)
        redirect_to signin_path
        return
      end
      @url5 = "https://flavumovies.herokuapp.com/directors.json"
      @all_directors =HTTParty.get(@url5, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@all_directors)
        redirect_to signin_path
        return
      end
      @url6 = "https://flavumovies.herokuapp.com/actors.json"
      @all_actors =HTTParty.get(@url6, body: {user: {auth_token: @token}}).parsed_response
      if !token_valid?(@all_actors)
        redirect_to signin_path
        return
      end

=end

#@all_actors['actors'].each do |all_actor|
#@x3= all_actor['name']
#@doc = Nokogiri::HTML(open("http://api.themoviedb.org/2.1/Person.search/en/xml/fe9909ee5e73ffa4e62bd0fdc584b4bb/#{@ap3}"))
#(@doc/:images/:image).each do |a|
#puts a['url']

    end
  end


  def edit
    #reset all the whole cookies
    cookies.delete(:auth, :auth_token=>'cookies[:auth]')
    cookies.signed[:guest_auth] = nil
    cookies.signed[:check_guest] == 'false'
    redirect_to cover_path

  end

  def settings 
    puts cookies.signed[:check_guest]
    if (!cookies.signed[:auth] && !cookies.signed[:guest_auth])
      redirect_to cover_path
    else
      if cookies.signed[:check_guest] == 'true'
        @user=cookies.signed[:user]
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: cookies.signed[:guest_auth]}}).parsed_response
        if !token_valid?(@user_preference)
          redirect_to signin_path
          return
        end  
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
      
        cookies.signed[:SO_radius] ||= @radius["value"]
        cookies.signed[:SO_unit] ||= @unit["value"]
        cookies.signed[:MLO_genres] ||= @show_genres["value"]
        cookies.signed[:MLO_actors] ||= @show_actors["value"]
        cookies.signed[:MLO_directors] ||= @show_directors["value"]
        cookies.signed[:MLO_raterun] ||= @show_rating_runtime["value"]
        cookies.signed[:TLO_address] ||= @show_address["value"]
        cookies.signed[:TLO_distance] ||= @show_distance["value"]
        cookies.signed[:TLO_phone_number] ||= @show_phone["value"]
        cookies.signed[:MO_liked_theatres] ||= @show_liked_theatres["value"]
        cookies.signed[:MO_nearby_theatres] ||= @show_nearby_theatres["value"]
        cookies.signed[:MO_disliked_theatres] ||= @show_disliked_theatres["value"]
          
        if params[:commit1] == "Update"
          @setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json",
          body: {user: {auth_token: cookies.signed[:guest_auth], email: params[:email], 
            username: params[:username],
            display_name: params[:display_name],
            phone_number: params[:phone_number],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
            }}).parsed_response
          if !token_valid?(@setting_account)
            redirect_to signin_path
            return
          end  
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
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], username: params[:username]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Update username is error. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your username is successful"   
            #flash[:error] = nil  
          #end

        #elsif params[:commit3] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], display_name: params[:display_name]}}).parsed_response
          #flash[:notice] = "Update your display name is successful"
          #flash[:notice] = nil

        #elsif params[:commit4] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], phone_number: params[:phone_number]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Your phone number has something wrong. Please try again" 
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your phone number is successful"
            #flash[:error] = nil
          #end

        #elsif params[:commit5] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], password: params[:password],
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
          if cookies.signed[:SO_radius] != params[:radius].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@radius['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @radius["preference"],
                  value: params[:radius]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end 
            cookies.signed[:SO_radius] = params[:radius]
          end
          
          if cookies.signed[:SO_unit] != params[:unit].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@unit['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @unit["preference"],
                  value: params[:unit]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:SO_unit] = params[:unit]
          end
            
            #@user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @a1}}).parsed_response
            #@radius_id = @user_preference['user_preferences'].third['id'].to_i
            #@unit_id = @user_preference['user_preferences'].last['id'].to_i
            #puts @radius_id
            #puts @unit_id
            #@radius2 =HTTParty.put("https://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json",
            #body: {
            #user: {auth_token: cookies.signed[:auth]} ,
            #user_preference: {preference: "search radius", value: params[:radius]}
            #}).parsed_response
            #@unit2 =HTTParty.put("https://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json",
            #body: {
            #user: {auth_token: cookies.signed[:auth]} ,
            #user_preference: {preference: "unit of measure", value: params[:unit]}
            #}).parsed_response
            
        elsif params[:commitMLO] == "Update"

            # TODO
            #if params[:genres]
          if cookies.signed[:MLO_genres] != params[:genres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_genres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_genres["preference"],
                  value: params[:genres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_genres] = params[:genres]
          end
            
          if cookies.signed[:MLO_actors] != params[:actors].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_actors['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_actors["preference"],
                  value: params[:actors]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_actors] = params[:actors]
          end
            
          if cookies.signed[:MLO_directors] != params[:directors].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_directors['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_directors["preference"],
                  value: params[:directors]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_directors] = params[:directors]
          end
            
          if cookies.signed[:MLO_raterun] != params[:raterun].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_rating_runtime['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_rating_runtime["preference"],
                  value: params[:raterun]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_raterun] = params[:raterun]
          end
            
            #if params[:actors]
            #cookies.signed[:MLO_actors] = params[:actors]
            #puts "actors is #{cookies.signed[:MLO_actors]}"
            #end
            #if params[:directors]
            #cookies.signed[:MLO_directors] = params[:directors]
            #end
            #if params[:raterun]
            #cookies.signed[:MLO_raterun] = params[:raterun]
            #end

        elsif params[:commitTLO] == "Update"

          if cookies.signed[:TLO_address] != params[:address].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_address['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_address["preference"],
                  value: params[:address]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_address] = params[:address]
          end
            
          if cookies.signed[:TLO_distance] != params[:distance].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_distance['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_distance["preference"],
                  value: params[:distance]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_distance] = params[:distance]
          end
            
          if cookies.signed[:TLO_phone_number] != params[:phone_number].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_phone['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_phone["preference"],
                  value: params[:phone_number]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_phone_number] = params[:phone_number]
          end
            
            #if params[:address]
            #cookies.signed[:TLO_address] = params[:address]
            #puts "address is #{cookies.signed[:TLO_address]}"
            #end
            #if params[:phone_number]
            #cookies.signed[:TLO_phone_number] = params[:phone_number]
            #puts "phone number is #{cookies.signed[:TLO_phone_number]}"
            #end
            #if params[:distance]
            #cookies.signed[:TLO_distance] = params[:distance]
            #end

        elsif params[:commitMO] == "Update"
          if cookies.signed[:MO_liked_theatres] != params[:liked_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_liked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_liked_theatres["preference"],
                  value: params[:liked_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_liked_theatres] = params[:liked_theatres]
          end
          
          if cookies.signed[:MO_nearby_theatres] != params[:nearby_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_nearby_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_nearby_theatres["preference"],
                  value: params[:nearby_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_nearby_theatres] = params[:nearby_theatres]
          end
            
          if cookies.signed[:MO_disliked_theatres] != params[:disliked_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_disliked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:guest_auth]
                },
                user_preference: {
                  preference: @show_disliked_theatres["preference"],
                  value: params[:disliked_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_disliked_theatres] = params[:disliked_theatres]
          end
            
            #if params[:likedt]
            #cookies.signed[:MO_likedt] = params[:likedt]
            #puts "liked teatres is #{cookies.signed[:MO_likedt]}"
            #end
            #if params[:near]
            #cookies.signed[:MO_near] = params[:near]
            #puts "nearby theatres is #{cookies.signed[:MO_near]}"
            #end
            #if params[:dist]
            #cookies.signed[:MO_dist] = params[:dist]
            #end

        end#commit
      
        #@account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
        #body: {user: {auth_token: cookies.signed[:guest_auth]}}).parsed_response
        #  puts params[:commit1]
        #  puts params[:commit2]
      


      else
     #@a1=cookies.signed[:auth]
        @user=cookies.signed[:user]
       # puts cookies.signed[:auth]
       # puts @a1
       
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
          
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
      
        cookies.signed[:SO_radius] ||= @radius["value"]
        cookies.signed[:SO_unit] ||= @unit["value"]
        cookies.signed[:MLO_genres] ||= @show_genres["value"]
        cookies.signed[:MLO_actors] ||= @show_actors["value"]
        cookies.signed[:MLO_directors] ||= @show_directors["value"]
        cookies.signed[:MLO_raterun] ||= @show_rating_runtime["value"]
        cookies.signed[:TLO_address] ||= @show_address["value"]
        cookies.signed[:TLO_distance] ||= @show_distance["value"]
        cookies.signed[:TLO_phone_number] ||= @show_phone["value"]
        cookies.signed[:MO_liked_theatres] ||= @show_liked_theatres["value"]
        cookies.signed[:MO_nearby_theatres] ||= @show_nearby_theatres["value"]
        cookies.signed[:MO_disliked_theatres] ||= @show_disliked_theatres["value"]
          
        if params[:commit1] == "Update"
          @setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json",
          body: {user: {auth_token: cookies.signed[:auth], email: params[:email], 
            username: params[:username],
            display_name: params[:display_name],
            phone_number: params[:phone_number],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            current_password: params[:current_password]
            }}).parsed_response
          puts params[:email]
          if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
          #puts @setting_account['errors']['email'].first
          if (@setting_account['errors'])
            flash[:error1] = "Somgething is error. Please try again" 
            flash[:notice1] = nil
          else
            flash[:notice1] = "Update your account is successful"
            flash[:error1] = nil
          end

        #elsif params[:commit2] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], username: params[:username]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Update username is error. Please try again"
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your username is successful"   
            #flash[:error] = nil  
          #end

        #elsif params[:commit3] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], display_name: params[:display_name]}}).parsed_response
          #flash[:notice] = "Update your display name is successful"
          #flash[:notice] = nil

        #elsif params[:commit4] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], phone_number: params[:phone_number]}}).parsed_response
          #if (@setting_account['errors'])
            #flash[:error] = "Your phone number has something wrong. Please try again" 
            #flash[:notice] = nil
          #else
            #flash[:notice] = "Update your phone number is successful"
            #flash[:error] = nil
          #end

        #elsif params[:commit5] == "Update"
          #@setting_account =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
          #body: {user: {auth_token: cookies.signed[:auth], password: params[:password],
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
          if cookies.signed[:SO_radius] != params[:radius].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@radius['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @radius["preference"],
                  value: params[:radius]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:SO_radius] = params[:radius]
          end
          
          if cookies.signed[:SO_unit] != params[:unit].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@unit['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @unit["preference"],
                  value: params[:unit]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:SO_unit] = params[:unit]
          end
            
            #@user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @a1}}).parsed_response
            #@radius_id = @user_preference['user_preferences'].third['id'].to_i
            #@unit_id = @user_preference['user_preferences'].last['id'].to_i
            #puts @radius_id
            #puts @unit_id
            #@radius2 =HTTParty.put("https://flavumovies.herokuapp.com/user_preferences/#{@radius_id}.json",
            #body: {
            #user: {auth_token: cookies.signed[:auth]} ,
            #user_preference: {preference: "search radius", value: params[:radius]}
            #}).parsed_response
            #@unit2 =HTTParty.put("https://flavumovies.herokuapp.com/user_preferences/#{@unit_id}.json",
            #body: {
            #user: {auth_token: cookies.signed[:auth]} ,
            #user_preference: {preference: "unit of measure", value: params[:unit]}
            #}).parsed_response
            
        elsif params[:commitMLO] == "Update"

            # TODO
            #if params[:genres]
          if cookies.signed[:MLO_genres] != params[:genres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_genres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_genres["preference"],
                  value: params[:genres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_genres] = params[:genres]
          end
            
          if cookies.signed[:MLO_actors] != params[:actors].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_actors['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_actors["preference"],
                  value: params[:actors]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_actors] = params[:actors]
          end
            
          if cookies.signed[:MLO_directors] != params[:directors].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_directors['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_directors["preference"],
                  value: params[:directors]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_directors] = params[:directors]
          end
            
          if cookies.signed[:MLO_raterun] != params[:raterun].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_rating_runtime['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_rating_runtime["preference"],
                  value: params[:raterun]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MLO_raterun] = params[:raterun]
          end
            
            #if params[:actors]
            #cookies.signed[:MLO_actors] = params[:actors]
            #puts "actors is #{cookies.signed[:MLO_actors]}"
            #end
            #if params[:directors]
            #cookies.signed[:MLO_directors] = params[:directors]
            #end
            #if params[:raterun]
            #cookies.signed[:MLO_raterun] = params[:raterun]
            #end

        elsif params[:commitTLO] == "Update"

          if cookies.signed[:TLO_address] != params[:address].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_address['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_address["preference"],
                  value: params[:address]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_address] = params[:address]
          end
            
          if cookies.signed[:TLO_distance] != params[:distance].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_distance['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_distance["preference"],
                  value: params[:distance]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_distance] = params[:distance]
          end
            
          if cookies.signed[:TLO_phone_number] != params[:phone_number].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_phone['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_phone["preference"],
                  value: params[:phone_number]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:TLO_phone_number] = params[:phone_number]
          end
            
            #if params[:address]
            #cookies.signed[:TLO_address] = params[:address]
            #puts "address is #{cookies.signed[:TLO_address]}"
            #end
            #if params[:phone_number]
            #cookies.signed[:TLO_phone_number] = params[:phone_number]
            #puts "phone number is #{cookies.signed[:TLO_phone_number]}"
            #end
            #if params[:distance]
            #cookies.signed[:TLO_distance] = params[:distance]
            #end

        elsif params[:commitMO] == "Update"
          if cookies.signed[:MO_liked_theatres] != params[:liked_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_liked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_liked_theatres["preference"],
                  value: params[:liked_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_liked_theatres] = params[:liked_theatres]
          end
          
          if cookies.signed[:MO_nearby_theatres] != params[:nearby_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_nearby_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_nearby_theatres["preference"],
                  value: params[:nearby_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_nearby_theatres] = params[:nearby_theatres]
          end
            
          if cookies.signed[:MO_disliked_theatres] != params[:disliked_theatres].to_s
            @setting_account=HTTParty.put("#{@user_preference_url}/#{@show_disliked_theatres['id']}.json",
              body: {
                user: {
                  auth_token: cookies.signed[:auth]
                },
                user_preference: {
                  preference: @show_disliked_theatres["preference"],
                  value: params[:disliked_theatres]
                }
              }
            )
            if !token_valid?(@setting_account)
              redirect_to signin_path
              return
            end
            cookies.signed[:MO_disliked_theatres] = params[:disliked_theatres]
          end
            
            #if params[:likedt]
            #cookies.signed[:MO_likedt] = params[:likedt]
            #puts "liked teatres is #{cookies.signed[:MO_likedt]}"
            #end
            #if params[:near]
            #cookies.signed[:MO_near] = params[:near]
            #puts "nearby theatres is #{cookies.signed[:MO_near]}"
            #end
            #if params[:dist]
            #cookies.signed[:MO_dist] = params[:dist]
            #end      
        end
       # puts params[:current_password]
       # @account1 =HTTParty.put("https://flavumovies.herokuapp.com/users.json", 
       # body: {user: {auth_token: cookies.signed[:auth],current_password: params[:current_password]}}).parsed_response
       # puts @account1

        @account =HTTParty.get("https://flavumovies.herokuapp.com/users/#{cookies.signed[:user_id]}.json", 
        body: {user: {auth_token: cookies.signed[:auth]}}).parsed_response
        if !token_valid?(@account)
          redirect_to signin_path
          return
        end
            puts params[:commit1]
            puts params[:commit2]
      
      end
    end
  end #def
  def home
    require 'address'
    #no more using

    #@lat_lng = cookies[:lat_lng]
    #@lat_lng2 = @lat_lng.split('|')
    #puts @lat_lng2[0]
        puts "auth#{cookies.signed[:auth]}"
        puts "guest#{cookies.signed[:guest_auth]}"
@ip = request.remote_ip
puts @ip
request.remote_ip
#@remote_ip = request.env["https_X_FORWARDED_FOR"]
#puts @remote_ip
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      @i2=s.addr.last
    end
    if (!cookies.signed[:auth]) && (!cookies.signed[:guest_auth])
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

      #cookies.signed[:latitude]=@latlong[0]
      #cookies.signed[:longitude]=@latlong[1]
      #30.267447, -97.739513
      cookies.permanent.signed[:latitude]="49.25"
      cookies.permanent.signed[:longitude]="-123.1333"
      #@lat_lng2
      puts cookies.signed[:latitude]
      puts cookies.signed[:longitude]
      #puts @ip_address
      puts cookies.signed[:check_guest]
      if ((!cookies.signed[:auth]) && (cookies.signed[:guest_auth]))
          cookies.signed[:check_guest] = "true"
      end
      
      if (cookies.signed[:check_guest] == 'true')
          @token=cookies.signed[:guest_auth]        
      else 
          @token=cookies.signed[:auth] 
      end

      #get_radius and unit
      if (cookies.signed[:SO_radius]) && (cookies.signed[:SO_unit])
        cookies.signed[:radius]=cookies.signed[:SO_radius]
        cookies.signed[:unit]=cookies.signed[:SO_unit] 
      end
      if (cookies.signed[:radius]) && (cookies.signed[:unit])
      else 
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @token}}).parsed_response
        if !token_valid?(@user_preference)
          redirect_to signin_path
          return
        end
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        cookies.signed[:radius]=@radius
        cookies.signed[:unit]=@unit
      end

      @url_movie = "https://flavumovies.herokuapp.com/movies_browser.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}&radius=#{cookies.signed[:radius]}&unit=#{cookies.signed[:unit]}"
      @movies =HTTParty.get(@url_movie, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
       if !token_valid?(@movies)
          redirect_to signin_path
          return
        end
      @rm=@movies['remaining_movies']
      @im=@movies['interested_movies']
      @nim=@movies['not_interested_movies']
    end
  end

  def signout
    #reset_cookies.signed 
    cookies.signed[:check_guest] = "true"
    cookies.signed[:auth] = nil
    cookies.signed[:facebook_auth]=nil
    puts "here"
    redirect_to root_path
  end


  def cover
    #@guests =HTTParty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: 'true'}}).parsed_response 
    #@guests1 =HTTParty.get("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {guest: "true"}}).parsed_response 
    #puts @guests1
    #puts @guests['auth_token']


  end

  def validate

  end

  def showtimes
    #no more using
    if (!cookies.signed[:auth] && !cookies.signed[:guest_auth])
      redirect_to cover_path
    else
      if cookies.signed[:check_guest] == 'true'
        @token=cookies.signed[:guest_auth]
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: cookies.signed[:guest_auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: cookies.signed[:guest_auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: cookies.signed[:guest_auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: cookies.signed[:guest_auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        end

      else
        @token=cookies.signed[:auth]
        if params[:liked]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: cookies.signed[:auth]}, liked_theatre: {theatre_id: params[:liked]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:unliked]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.post(@url, body: {user: {auth_token: cookies.signed[:auth]}, not_interested_theatre: {theatre_id: params[:unliked]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:soso1]
          @url = "https://flavumovies.herokuapp.com/liked_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: cookies.signed[:auth]}, liked_theatre: {theatre_id: params[:soso1]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        elsif params[:soso2]
          @url = "https://flavumovies.herokuapp.com/not_interested_theatres.json"
          @theatres =HTTParty.delete(@url, body: {user: {auth_token: cookies.signed[:auth]}, not_interested_theatre: {theatre_id: params[:soso2]} }).parsed_response
          if !token_valid?(@theatres)
            redirect_to signin_path
            return
          end
        end
      end

      #get_radius and unit
      if (cookies.signed[:SO_radius]) && (cookies.signed[:SO_unit]) 
        cookies.signed[:radius]=cookies.signed[:SO_radius]
        cookies.signed[:unit]=cookies.signed[:SO_unit] 
      else 
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @token}}).parsed_response
        if !token_valid?(@user_preference)
            redirect_to signin_path
            return
        end
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        cookies.signed[:radius]=@radius
        cookies.signed[:unit]=@unit
      end

      @url = "https://flavumovies.herokuapp.com/theatres.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}&radius=#{cookies.signed[:radius]}&unit=#{cookies.signed[:unit]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
      if !token_valid?(@theatres)
        redirect_to signin_path
        return
      end
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
    end 
  end

  def showmovie

    if (!cookies.signed[:auth] && !cookies.signed[:guest_auth])
      redirect_to cover_path
    else
        #puts cookies.signed[:check_guest]
        #puts cookies.signed[:auth]
        #puts cookies.signed[:guest_auth]
        #puts params[:showid1]
        #puts params[:showid2]
        #puts params[:showid3]
        #recieve parameters from movie page
        @url = "https://flavumovies.herokuapp.com/movies/#{params[:showid]}.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}"

        if cookies.signed[:check_guest] == "true"
          @token=cookies.signed[:guest_auth]
          if params[:showid]#should be movies in theatres page
            @id_showmovie = params[:showid]
          end      

        else
          @token=cookies.signed[:auth]
          if params[:showid]#should be movies in theatres page
            @id_showmovie = params[:showid]
            cookies.signed[:showmovie_id] = @id_showmovie
          end  
        end
        @movies =HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
        if !token_valid?(@movies)
          redirect_to signin_path
          return
        end
        @sm=@movies['movie']
        @theatres_for_movie=@movies['movie']['theatres']
        
    end

  end

  def boxoffice
    #no more using
    @url = "https://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&apikey=ufqydfp3jtp9ytyr69j37835"
    @boxoffice =HTTParty.get(@url).parsed_response
    
  end

  def news
    #no more using
    #fetch data from Google News API
    @news =HTTParty.get("http://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=movie&rsz=8").parsed_response
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
    #no more using
    #@url1 = "https://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?review_type=all&limit=20&apikey=ufqydfp3jtp9ytyr69j37835"
    #@boxoffice =HTTParty.get(@url1).parsed_response
    @url = "https://flavumovies.herokuapp.com/movies.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}"
    @movies =HTTParty.get(@url, body: {user: {auth_token: cookies.signed[:auth]  }, browser: "1"}).parsed_response
    @rm=@movies['remaining_movies']
    @im=@movies['interested_movies']
    @nim=@movies['not_interested_movies']


    #@url2 = "https://api.rottentomatoes.com/api/public/v1.0/movies/#{@movie_id}/reviews.json?review_type=top_cirtic&apikey=ufqydfp3jtp9ytyr69j37835"
    #@review =HTTParty.get(@url2).parsed_response
  end

  def showreview
    #no more using
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

    #@url2 = "https://api.rottentomatoes.com/api/public/v1.0/movies/#{params[:id]}/reviews.json?page_limit=1&apikey=ufqydfp3jtp9ytyr69j37835"
    #@reviews=HTTParty.get(@url2).parsed_response
    #puts @reviews
  end

  def confirm_account
    #confirm the account by send parameters to the API
    puts params[:confirmation_token]
    @url = "https://flavumovies.herokuapp.com/users/confirmation.json"
    @confirm_account =HTTParty.get(@url, body: {confirmation_token: params[:confirmation_token]}).parsed_response
    cookies.signed[:auth]=@confirm_account['auth_token']   
    redirect_to root_path
  end

  def forgot_password
    #Confirmation will be sent to the email in order to reset the password
    if params[:confirm] =="confirm"
      puts params[:email]
      #puts params[:confirmation_token]
      @url = "https://flavumovies.herokuapp.com/users/password.json"
      @forgot_password =HTTParty.post(@url, body: {user: {email: params[:email]}})
      puts @forgot_password
    else
    end
  end

  def reset_password
    #puts params[:reset_password_token]
    #cookies.signed[:reset_password_token] = params[:reset_password_token]
    #puts params[:reset_password_token]
    #After people recieved the email, this controller will send token to the API to confirm the user
      @password_reset_token=params[:reset_password_token]

    if params[:confirm]=="confirm"
      puts "yes"
      puts params[:password]
      puts params[:password_confirmation]       
      @url = "https://flavumovies.herokuapp.com/users/password.json"
      @password_reset_token =HTTParty.put(@url, body: { user: {reset_password_token: params[:reset_password], password: params[:password], password_confirmation: params[:password_confirmation] }}).parsed_response
      cookies.signed[:auth]=@password_reset_token['auth_token']   
      puts @password_reset_token
      redirect_to root_path
    else

    end

  end

  def idevice
    if params[:reset_password_token]
      @reset_password_token = params[:reset_password_token]
    elsif params[:confirmation_token]
      @confirmation_token = params[:confirmation_token]
    end
  end

  def token_valid?(*hash)
    #valid  the auth token
    if hash.length > 0 && hash[0]["error"] == "Invalid authentication token."
      cookies.signed[:auth] = nil
      return false
    end
    return true
  end

  def authenticate_user
    if !cookies.signed[:auth]
      if !cookies.signed[:guest_auth] or cookies.signed[:guest_auth] && cookies.signed[:check_guest] == "false"
        redirect_to signin_path
        return
      end
    end
  end

  def trailers
    #no more using
    if (!cookies.signed[:auth]) && (!cookies.signed[:guest_auth])
      redirect_to cover_path
    else

      if (cookies.signed[:check_guest] == 'true')
          @token=cookies.signed[:guest_auth]        
      else 
          @token=cookies.signed[:auth] 
      end
      puts @token
      #get_radius and unit
      if (cookies.signed[:SO_radius]) && (cookies.signed[:SO_unit])
        cookies.signed[:radius]=cookies.signed[:SO_radius]
        cookies.signed[:unit]=cookies.signed[:SO_unit] 
      end
      if (cookies.signed[:radius]) && (cookies.signed[:unit])
      else 
        @user_preference_url = "https://flavumovies.herokuapp.com/user_preferences"
        @user_preference =HTTParty.get("https://flavumovies.herokuapp.com/user_preferences.json", body: {user: {auth_token: @token}}).parsed_response
        @radius = @user_preference["user_preferences"].find{|x| x["preference"] == "search radius"}
        @unit = @user_preference["user_preferences"].find{|x| x["preference"] == "unit of measure"}
        cookies.signed[:radius]=@radius
        cookies.signed[:unit]=@unit
      end
        
      @url = "https://flavumovies.herokuapp.com/movie_trailers.json?latitude=#{cookies.signed[:latitude]}&longitude=#{cookies.signed[:longitude]}&radius=#{cookies.signed[:radius]}&unit=#{cookies.signed[:unit]}"
      @movies = HTTParty.get(@url, body: {user: {auth_token: @token}, browser: "1"}).parsed_response
      if !token_valid?(@movies)
        redirect_to signin_path
        return
      end
      @rm = @movies['remaining_movies']
      @im = @movies['interested_movies']
      @nim = @movies['not_interested_movies']

    end
  end

  def facebook

    @token = request.env['omniauth.auth']['credentials']['token']
    #puts "token = #{@token}"
    puts cookies.signed[:auth]
    #sign in via facebook
    @facebook =HTTParty.post("https://flavumovies.herokuapp.com/social_accounts/facebook/sign_in.json", body: {access_token: @token}).parsed_response
    
    puts "aaa = #{@facebook['auth_token']}"

    cookies.permanent.signed[:facebook_auth]=@token
    if @facebook['auth_token']
      cookies.permanent.signed[:auth] = @facebook["auth_token"]
      @facebook_link =HTTParty.post("https://flavumovies.herokuapp.com/social_accounts/facebook/link.json", body: {access_token: cookies.signed[:facebook_auth], auth_token: cookies.signed[:auth]}).parsed_response
      @social_accounts=HTTParty.get("https://flavumovies.herokuapp.com/social_accounts.json", body: {auth_token: cookies.signed[:auth]}).parsed_response
      
      redirect_to root_path
    else
      flash[:error]=@facebook['error']

      redirect_to signin_path
    end
    #@facebook_login = HTTParty.post("https://flavumovies.herokuapp.com/social_accounts/facebook/sign_in.json", body: {access_token: @token}).parsed_response

=begin      
      token = env["omniauth.auth"]["credentials"]["token"]
      
        @user = HTTParty.post("https://flavumovies.herokuapp.com/other_logins/facebook.json", body: {access_token: token}).parsed_response
      
        cookies.permanent.signed[:auth] = @user["auth_token"]
        cookies.permanent.signed[:username] = @user["username"]
        cookies.permanent.signed[:user_id] = @user["id"]
        cookies.permanent.signed[:user] = @user
      
    redirect_to root_path
  
=end

  end

  def link_fb
    #link to the facebook in order to allow the app access facebook profile
      @facebook_link =HTTParty.post("https://flavumovies.herokuapp.com/social_accounts/facebook/link.json", body: {access_token: cookies.signed[:facebook_auth], auth_token: cookies.signed[:auth]}).parsed_response
      @social_accounts=HTTParty.get("https://flavumovies.herokuapp.com/social_accounts.json", body: {auth_token: cookies.signed[:auth]}).parsed_response
      puts @social_accounts
      cookies.signed[:social_accounts]=@social_accounts['linked_accounts']
      puts cookies.signed[:social_accounts]
      #puts @facebook_link
      redirect_to :back

  end

  def unlink_fb
      #unlink from facebook
      @facebook_link =HTTParty.post("https://flavumovies.herokuapp.com/social_accounts/facebook/unlink.json", body: {auth_token: cookies.signed[:auth]}).parsed_response
      @social_accounts=HTTParty.get("https://flavumovies.herokuapp.com/social_accounts.json", body: {auth_token: cookies.signed[:auth]}).parsed_response
      cookies.signed[:social_accounts]=@social_accounts['linked_accounts']
      puts cookies.signed[:social_accounts]
      cookies.signed[:facebook_auth]=nil
      #puts @facebook_link['response']
      redirect_to :back
    end

   def share
        #puts cookies.signed[:facebook_auth]
        #puts "text=#{params[:text]}"
        #share page via facebook by using gem
        @id=params[:showid]
        @poster=params[:poster]
        @synopsis=params[:synopsis]
        @title_name=params[:title_name]
        me = FbGraph::User.me(cookies.signed[:facebook_auth])
        me.feed!(
          :message => @title_name,
          :picture => @poster,
          :link => 'http://www.flavu.com/showmovie?showid='+@id,
          :name => 'Flavu Movies',
          :description => @synopsis
        )

        redirect_to :back            
  end

  def myopinion
    
  end

  def search
    puts params[:taste]
    
  end


end
