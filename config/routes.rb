Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  
  defaults format: 'json' do
    resources :users, only: [:create, :update, :index, :show]
    get 'agents/:id/', to: 'users#agents'
    get 'agents/:id/purpose', to: 'users#purpose'
    get 'agents', to: 'users#search_agents'
    get 'verify/user', to: 'users#verify_user'

    resources :transactions

    get 'subscribe/:id', to: 'subscriptions#subscriber'
    get 'my-subscription', to: 'subscriptions#index'

    get 'subscribe-banner/:id', to: 'banner_ad_subscriber#subscriber'

    resources :banner_ads

    resources :posts
    resources :posts, :path=> '', except: [:index]
    get 'q/search', to: 'posts#search'
    resources :posts, only: [:delete_image_attachment] do
      member do
        delete :delete_image_attachment
      end
    end

    resources :post_requests, except: [:index, :show]
    # get 'p/requests', to: 'post_requests#index'
    get 'p/requests/:id', to: 'post_requests#show'
    get 'p/requests', to: 'post_requests#search'


    root 'posts#index'
  end
end
