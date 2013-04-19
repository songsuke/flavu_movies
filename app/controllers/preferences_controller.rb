class PreferencesController < ApplicationController
  # GET /preferences
  # GET /preferences.json
  def index
    if (!session[:auth] && !session[:guest_auth])
      redirect_to cover_path
    else
      if session[:check_guest] == 'true'
        @url1 = "http://flavumovies.herokuapp.com/genre_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @url2 = "http://flavumovies.herokuapp.com/director_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @url3 = "http://flavumovies.herokuapp.com/actor_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @genre_preferences =HTTParty.get(@url1, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @director_preferences =HTTParty.get(@url2, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        @actor_preferences =HTTParty.get(@url3, body: {user: {auth_token: session[:guest_auth]}}).parsed_response
        

        @url4 = "http://flavumovies.herokuapp.com/genres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
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


        puts @a1
        @preferences=Preference.all
       #@genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
      # @director_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/director_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
       #@actor_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/actor_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']


      else
        @a1=session[:auth]
        puts session[:auth]
        @url1 = "http://flavumovies.herokuapp.com/genre_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @url2 = "http://flavumovies.herokuapp.com/director_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @url3 = "http://flavumovies.herokuapp.com/actor_preferences.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @genre_preferences =HTTParty.get(@url1, body: {user: {auth_token: session[:auth]}}).parsed_response
        @director_preferences =HTTParty.get(@url2, body: {user: {auth_token: session[:auth]}}).parsed_response
        @actor_preferences =HTTParty.get(@url3, body: {user: {auth_token: session[:auth]}}).parsed_response
        

        @url4 = "http://flavumovies.herokuapp.com/genres.json?latitude=#{session[:latitude]}&longitude=#{session[:longitude]}"
        @all_genres =HTTParty.get(@url4, body: {user: {auth_token: session[:auth]}}).parsed_response
        @genre_update =HTTParty.put("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre] ,score: params[:score]}}).parsed_response
        puts @x1
        puts params[:score]
        puts params[:genre]

        @genre_create =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_create] ,score: params[:score]}}).parsed_response
     
        @genre_delete =HTTParty.delete("http://flavumovies.herokuapp.com/genre_preferences/1.json", body: {user: {auth_token: session[:auth]}, genre_preference: {genre: params[:genre_delete] ,score: params[:score]}}).parsed_response
        puts params[:genre_delete]
      
      
      #@genre_update =HTTParty.post("http://flavumovies.herokuapp.com/genre_preferences.json", 
      #  body: {user: {auth_token: @session[:auth]}, genre_preference: {genre: params[:genre],score: params[:score]}}).parsed_response


        puts session[:auth]
        @preferences=Preference.all
     #@genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
    # @director_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/director_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
     #@actor_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/actor_preferences.json?auth_token=kczrVERyuJu6RgevHZCx").read) 
        @gp=@genre_preferences['genre_preferences']
        @dp=@director_preferences['director_preferences']
        @ap=@actor_preferences['actor_preferences']
      end
    end

  end

  # GET /preferences/1
  # GET /preferences/1.json
  def show
    @preference = Preference.find(params[:id])
    @genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=3FfbfMMb7Ewr27AEd3S9").read) 
    @gp=@genre_preferences['genre_preferences']
    @gp.each do |a1|
      @a2=a1['id']
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @preference }

    end
  end

  # GET /preferences/new
  # GET /preferences/new.json
  def new
    @preference = Preference.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
        @preference = Preference.new

    @genre_preferences=JSON.parse(open("http://flavumovies.herokuapp.com/genre_preferences.json?auth_token=3FfbfMMb7Ewr27AEd3S9").read) 
    @gp=@genre_preferences['genre_preferences']
    @preference = @gp
   
    respond_to do |format|
    format.html
    format.json {
      render :json => {
      :genre_preference => @genre_prefernce.attributes.merge!(:genre => @genre_preference.genre.name)
    }
    }
  end

  end

  # POST /preferences
  # POST /preferences.json
  def create
    @preference = Preference.new(params[:preference])

    respond_to do |format|
      if @preference.save
        format.html { redirect_to @preference, notice: 'Preference was successfully created.' }
        format.json { render json: @preference, status: :created, location: @preference }
      else
        format.html { render action: "new" }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.json
  def update
    @preference = Preference.find(params[:id])

    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        format.html { redirect_to @preference, notice: 'Preference was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.json
  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to preferences_url }
      format.json { head :no_content }
    end
  end
end
