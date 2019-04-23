Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  
  defaults format: 'json' do
    resources :users, only: [:create, :update, :index, :show]
    get 'agents/:id/', to: 'users#agents'
    get 'agents/:id/purpose', to: 'users#purpose'
    get 'agents', to: 'users#search_agents'

    resources :posts
    resources :posts, :path=> '', except: [:index]
    get 'q/search', to: 'posts#search'

    resources :post_requests, except: [:index, :show]
    get 'p/requests', to: 'post_requests#index'
    get 'p/requests/:id', to: 'post_requests#show'


    root 'posts#index'
  end
end
