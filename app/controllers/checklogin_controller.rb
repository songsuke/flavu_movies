class CheckloginController < ApplicationController
	layout 'cover'
def checklogin
    if params[:confirm] !="confirm"
    else
      
      puts "my param #{params[:login]}"
      @users =httpsarty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
      puts @users.first[0]
      if (@users.first[0]=="error")
        flash[:error] = "Username or Password is wrong. Please try again"
        #session[:check_guest] ={secure: true, httponly: true, domain: 'flavu.com', value: "true"}
        session[:check_guest] ="true"
        puts session[:check_guest]
        redirect_to home_path
      else
        puts @users
        @auth_token=@users['auth_token']
        session[:username] = @users['username']
        #session[:username] ={secure: true, httponly: true, domain: 'flavu.com', value: "true"}        
        session[:user] = @users
        session[:auth] = @auth_token
        #session[:auth] ={secure: true, httponly: true, domain: 'flavu.com', value: "#{@auth_token}"}

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
