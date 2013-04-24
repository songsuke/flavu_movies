class CoverController < ApplicationController
	layout 'cover'

  def cover
  	puts params[:guest]
	if session[:check_guest] == 'true' && params[:guest] == 'true'
		redirect_to root_path
	elsif params[:guest] == 'true'
		@guest_password=SecureRandom.uuid
		@guest_gen=SecureRandom.uuid
		@guest_email= @guest_gen + "@flavuguest.com"

		#@guest_displayname=SecureRandom.uuid

	  	@guests =HTTParty.post("http://flavumovies.herokuapp.com/users.json", body: {user: {password: @guest_password, password_confirmation: @guest_password, email: @guest_email, username: @guest_gen, display_name: @guest_gen, guest: params[:guest], browser: "1"}}).parsed_response
	    puts @guests['id']
	    puts @guests
	    session[:guest]=@guests
	    session[:check_guest]="true"
	    session[:guest_auth]=@guests['auth_token']
	    puts @guests['guest']
	    puts @guests['username']
	    puts session[:guest_auth]
	    puts @guests['auth_token']
	    redirect_to home_path

		
	else

	end
  end
end
