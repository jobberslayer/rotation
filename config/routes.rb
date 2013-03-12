Rotation::Application.routes.draw do

  get "groups/index"

  resources :volunteers do
    member do
      get :groups
    end
  end

  match '/volunteers/:volunteer_id/join_group/:group_id', to: 'volunteers#join_group', :as => :join_group_volunteer
  match '/volunteers/:volunteer_id/leave_group/:group_id', to: 'volunteers#leave_group', :as => :leave_group_volunteer

  resources :groups do
    member do
      get :volunteers
    end
  end

  match '/groups/:group_id/add_volunteer/:volunteer_id', to: 'groups#add_volunteer', :as => :add_volunteer_group
  match '/groups/:group_id/remove_volunteer/:volunteer_id', to: 'groups#remove_volunteer', :as => :remove_volunteer_group

  resources :sessions, only: [:new, :create, :destroy]

  root to: 'news#index'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/profile/update', to: 'users#update'
  match '/profile', to: 'users#edit'

  match '/schedule/:year/:month/:day', to: "schedules#list", :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ }, :as => 'list_schedule' 
  match '/schedule/:year/:month/:day/edit/:group_id', to: "schedules#edit", :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :group_id => /\d{1,}/ }, :as => 'edit_schedule' 
  match '/schedule', to: 'schedules#index', :as => 'index_schedule'

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
