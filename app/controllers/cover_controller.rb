class CoverController < ApplicationController
	layout 'cover'

  def cover
  	puts params[:guest]
	if session[:check_guest] == 'true' && params[:guest] == 'true'
		redirect_to root_path
	elsif params[:guest] == 'true'
	@guest_password=SecureRandom.uuid
	@guest_email= SecureRandom.uuid + "@" + SecureRandom.uuid + ".com"
	@guest_username=SecureRandom.uuid
	@guest_displayname=SecureRandom.uuid

  	@guests =HTTParty.post("http://flavumovies.herokuapp.com/users.json", body: {user: {password: @guest_password, password_confirmation: @guest_password, email: @guest_email, username: @guest_username, display_name: @guest_displayname, guest: params[:guest] }}).parsed_response
    puts @guests['id']
    puts @guests
    session[:guest]=@guests
    session[:check_guest]="true"
    session[:guest_auth]=@guests['auth_token']
    puts @guests['guest']
    puts @guests['username']
    puts session[:guest_auth]
    puts @guests['auth_token']
    redirect_to root_path

	else

	end
  end
end
