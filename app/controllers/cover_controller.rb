class CoverController < ApplicationController
	layout 'cover'

  def cover
  	puts params[:guest]
	if cookies.signed[:check_guest] == 'true' && params[:guest] == 'true' && cookies.signed[:guest_auth]
		redirect_to root_path
	elsif params[:guest] == 'true'
		@guest_password=SecureRandom.uuid
		@guest_gen=SecureRandom.uuid
		puts @guest_password
		@guest_email= @guest_gen + "@flavuguest.com"

		#@guest_displayname=SecureRandom.uuid

	  	@guests =HTTParty.post("https://flavumovies.herokuapp.com/users.json", body: {user: {email: @guest_email, username: @guest_gen, password: @guest_password, password_confirmation: @guest_password, display_name: @guest_gen, guest: params[:guest]}}).parsed_response
	    puts @guests['id']
	    #puts @guests
	    cookies.permanent.signed[:guest]={value: "#{@guests}"}
	    cookies.permanent.signed[:check_guest]={value: "true"}
	    cookies.permanent.signed[:guest_auth]={value: "#{@guests['auth_token']}"}
        #cookies.signed[:guest_auth] ={secure: true, httponly: true, domain: 'flavu.com', value: "#{@guests['auth_token']}"}

	    #puts @guests['guest']
	    #puts @guests['username']
	    #puts cookies.signed[:guest_auth]
	    #puts @guests['auth_token']
	    redirect_to root_path
	elsif cookies.signed[:auth] || cookies.signed[:guest_auth]
		redirect_to home_path

		
	else

	end
  end
end
