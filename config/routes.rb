EasilyxMovie::Application.routes.draw do
  match '/cover', to: 'cover#cover'

  #resources :preferences
  match '/validate', to: 'static_pages#validate'
  match '/showtimes', to: 'static_pages#showtimes'
  match '/checklogin', to: 'checklogin#checklogin'
  match '/showmovie', to: 'static_pages#showmovie'
  match '/showtheatre', to: 'static_pages#showtheatre'
  match '/preferences', to: 'static_pages#preferences'
  match '/boxoffice', to: 'static_pages#boxoffice'
  match '/news', to: 'static_pages#news'
  match '/reviews', to: 'static_pages#reviews'
  match '/showreview', to: 'static_pages#showreview'
  match '/confirm_account', to: 'static_pages#confirm_account'
  match '/forgot_password', to: 'static_pages#forgot_password'
  match '/reset_password', to: 'static_pages#reset_password'
  match '/trailers', to: 'static_pages#trailers'
  match '/contact', to: 'static_pages#contact'
  match '/aboutus', to: 'static_pages#aboutus'
  match '/idevice', to: 'static_pages#idevice'
match '/auth/:provider/callback', to: 'static_pages#facebook'
    match '/link_fb', to: 'static_pages#link_fb'
match '/share', to: 'static_pages#share'

  #get "static_pages/signin"
  match '/signin', to: 'static_pages#signin'

  #get "static_pages/register"
  match '/register', to: 'static_pages#register'

  #get "static_pages/movies"
  match '/movies', to: 'static_pages#movies'

  #get "static_pages/theatres"
  match '/theatres', to: 'static_pages#theatres'

 # get "static_pages/preferences"

 # get "static_pages/settings"
  match '/settings', to: 'static_pages#settings'

  #get "static_pages/buddies"
  match '/buddies', to: 'static_pages#buddies'
  match '/signout', to: 'static_pages#signout'

  #get "static_pages/home"
  match '/home', to: 'static_pages#home'
  match '/edit', to: 'static_pages#edit'
  #match '/cover', to: 'static_pages#cover'
  resources :static_pages

  root to: 'static_pages#home'
 # root :to => 'posts#index'
  #match '/index', to: 'preferences#index'
  #match '/edit', to: 'preferences#edit'
  #match '/show', to: 'preferences#show'
  #resources :preferences


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
