class CoverController < ApplicationController
	layout 'cover'

  def cover
  	puts params[:guest]
	if session[:check_guest] == 'true' && params[:guest] == 'true' && session[:guest_auth]
		redirect_to root_path
	elsif params[:guest] == 'true'
		@guest_password=SecureRandom.uuid
		@guest_gen=SecureRandom.uuid
		puts @guest_password
		@guest_email= @guest_gen + "@flavuguest.com"

		#@guest_displayname=SecureRandom.uuid

	  	@guests =httpsarty.post("https://flavumovies.herokuapp.com/users.json", body: {user: {email: @guest_email, username: @guest_gen, password: @guest_password, password_confirmation: @guest_password, display_name: @guest_gen, guest: params[:guest]}}).parsed_response
	    puts @guests['id']
	    puts @guests
	    session[:guest]=@guests
	    session[:check_guest]="true"
	    session[:guest_auth]=@guests['auth_token']
        #session[:guest_auth] ={secure: true, httponly: true, domain: 'flavu.com', value: "#{@guests['auth_token']}"}

	    puts @guests['guest']
	    puts @guests['username']
	    puts session[:guest_auth]
	    puts @guests['auth_token']
	    redirect_to root_path
	elsif session[:auth] || session[:guest_auth]
		redirect_to home_path

		
	else

	end
  end
end
