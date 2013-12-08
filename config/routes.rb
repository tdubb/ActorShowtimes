ActorShowtimes::Application.routes.draw do
 
 
  root 'actors#new'
  get '/actors' => 'actors#index', as: 'index'
  resources :actors
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  resources :users do
    resources :actors, only: [:index, :show]
  end


  get '/signup' => 'users#new'
  get '/signin' => 'sessions#new', as: :signin
  post 'signin', controller: :logins, action: :create
  get '/singout' => 'sessions#destroy'

  # get 'signin', controller: :logins, action: :new, as: :signin
  # post 'signin', controller: :logins, action: :create
  # delete 'logout', controller: :logins, action: :destroy, as: :logout

  # root 'actors#new'
  # get '/actors' => 'actors#index'
  # get "/actors/new" => 'actors#new', as: 'new_actor'
  # post '/actors' => 'actors#create'
  # get "/actors/index" => 'actors#index', as: 'actor_index'
  # delete "/actors/:id" => 'actors#destroy'
  # get "/actors/:id" => 'actors#show', as: 'actor'
 
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
