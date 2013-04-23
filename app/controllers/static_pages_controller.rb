class StaticPagesController < ApplicationController
require 'httparty'
require 'open-uri'

  def signin
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
        puts session[:check_guest]
        puts session[:auth]
        puts session[:guest_auth]
        if session[:check_guest] == "true"
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']
          @liked_movies =HTTParty.post("http://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, interested_movie: { movie_id:params[:liked] ,interested: "true"}}).parsed_response
          @unliked_movies =HTTParty.post("http://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:guest_auth]}, not_interested_movie: { movie_id:params[:unliked] ,not_interested: "true"}}).parsed_response
        else
          @url = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
          @movies =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}}).parsed_response
          @rm=@movies['remaining_movies']
          @im=@movies['interested_movies']
          @nim=@movies['not_interested_movies']
          @liked_movies =HTTParty.post("http://flavumovies.herokuapp.com/interested_movies.json", body: {user: {auth_token: session[:auth]}, interested_movie: { movie_id:params[:liked] ,interested: "true"}}).parsed_response
          @unliked_movies =HTTParty.post("http://flavumovies.herokuapp.com/not_interested_movies.json", body: {user: {auth_token: session[:auth]}, not_interested_movie: { movie_id:params[:unliked] ,not_interested: "true"}}).parsed_response
          
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
      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:guest_auth]}}).parsed_response

      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
      else
      @url = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
      @theatres =HTTParty.get(@url, body: {user: {auth_token: session[:auth]}}).parsed_response

      #@theatres=JSON.parse(open("http://flavumovies.herokuapp.com/theatres.json?auth_token=ZhhSqcdR2T6KoVv29UZp").read) 
      @lt=@theatres['liked_theatres']
      @nt=@theatres['nearby_theatres']
      @nit=@theatres['not_interested_theatres']
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
puts params[:unblock]
    puts params[:follow]
    puts @following
    puts params[:friend_contact_info]
  else
    
  end
  
  end

  def preferences
  
  end
  def edit
    reset_session
    redirect_to cover_path
    
    
  end
  def settings 
    
    
    if (session[:auth])
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

    else
      redirect_to home_path
    end

  end

  def home
    require 'address'
    #@lat_lng = cookies[:lat_lng]
    #@lat_lng2 = @lat_lng.split('|')
    #puts @lat_lng2[0]

    #puts @lat_lng
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      #@ip_address=open( "http://jsonip.com/" ){ |s| JSON::parse( s.string())['ip'] }
      #@ip_address = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
      #@ip_address=Address.get
      @ip_address="184.70.5.250"
      @latlong=Geocoder.coordinates(@ip_address)

      session[:latitude]=@latlong[0]
      session[:longitude]=@latlong[1]
      #session[:latitude]=@lat_lng2[0]
      #session[:longitude]=@lat_lng2[1]
      #@lat_lng2
      puts session[:latitude]
      puts session[:longitude]
      #puts @ip_address
      if session[:check_guest] == 'true'
        @url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @nt=@theatres['nearby_theatres']
        @url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @rm=@movies['remaining_movies']
      else 
        @url_theatre = "http://flavumovies.herokuapp.com/theatres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @theatres =HTTParty.get(@url_theatre, body: {user: {auth_token: session[:auth]}}).parsed_response
        @nt=@theatres['nearby_theatres']
        @url_movie = "http://flavumovies.herokuapp.com/movies.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @movies =HTTParty.get(@url_movie, body: {user: {auth_token: session[:auth]}}).parsed_response
        @rm=@movies['remaining_movies']
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



end
