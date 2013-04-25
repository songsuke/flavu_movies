class CheckloginController < ApplicationController
	layout 'cover'
def checklogin
    if params[:confirm] !="confirm"
    else
      
      puts "my param #{params[:login]}"
      @users =HTTParty.post("http://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
      puts @users.first[0]
      if (@users.first[0]=="error")
        flash[:error] = "Username or Password is wrong. Please try again"
        session[:check_guest] ="true"
        redirect_to home_path
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
        session[:check_guest] = "false"
        redirect_to home_path
      end
    end
end
end
