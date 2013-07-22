class Preference < ActiveRecord::Base
  attr_accessible :body, :title, [:id, :user_id, :genre_id, :score, :created_at, :updated_at, :genre]   
     
end
