class CheckloginController < ApplicationController
	layout 'cover'
def checklogin
    if params[:confirm] !="confirm"
    else
      
      puts "my param #{params[:login]}"
      @users =HTTParty.post("https://flavumovies.herokuapp.com/users/sign_in.json", body: {user: {login: params[:login], password: params[:password]}}).parsed_response 
      puts @users.first[0]
      if (@users.first[0]=="error")
        flash[:error] = "Username or Password is wrong. Please try again"
        #cookies.signed[:check_guest] ={secure: true, httponly: true, domain: 'flavu.com', value: "true"}
        cookies.permanent.signed[:check_guest] ="true"
        #puts cookies.signed[:check_guest]
        redirect_to home_path
      else
        cookies.permanent.signed[:username] = {value: "#{@users['username']}"}
        #cookies.signed[:username] ={secure: true, httponly: true, domain: 'flavu.com', value: "true"}        
        cookies.permanent.signed[:user] = {value: "#{@users}"}
        if checkbox[check]]=1
          cookies.permanent.signed[:auth] = {secure: true,value: "#{@users['auth_token']}"}
          puts "yes#{params[:checkbox]}"
        elsif checkbox[check]]=0
          cookies.signed[:auth] = {secure: true,value: "#{@users['auth_token']}"}
          puts "no"
        end
        #cookies.signed[:auth] ={secure: true, httponly: true, domain: 'flavu.com', value: "#{@auth_token}"}
        #cookies.signed[:latitude] = '49.28385281'
       # cookies.signed[:longitude] = '-123.1120815'
        #@username=cookies.signed[:username]
        #@auth=cookies.signed[:auth]
        cookies.permanent.signed[:check_guest] = {value: "false"}
        redirect_to home_path
      end
    end
end
end
