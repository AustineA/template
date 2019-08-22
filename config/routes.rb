Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  defaults format: 'json' do
    patch 'users/change-password', to: 'users#change_password'
    patch 'users/iforgot', to: 'users#iforgot'
    resources :users, only: [:create, :update, :index, :show, :destroy]
    delete 'users/delete-avatar/:id', to: 'users#destroy_avatar'
    get 'agents/:id/', to: 'users#agents'
    get 'agents/:id/purpose', to: 'users#purpose'
    get 'agents', to: 'users#search_agents'
    get 'verify/user', to: 'users#verify_user'
    get 'verify/user-data', to: 'users#verify_user_data'
    get 'verify/max-post', to: 'users#check_max_post'
    get 'user-stats', to: 'users#user_stats'

    get 'admin', to: "admins#home"
    get 'admin/users', to: "admins#search_users"
    get 'admin/plans', to: "admins#users_by_plan"
    get 'admin/upgrade', to: "admins#upgrade"
    get 'admin/stats', to: "admins#users_stats"
    get 'admin/all-posts',  to: "admins#search_posts"
    get 'admin/all-banners',  to: "admins#banners"
    get 'admin/all-brands',  to: "admins#brands"
    get 'admin/reports', to: "admins#reported"
    get 'admin/all', to: "admins#admins"
    get 'admin/verify', to: "admins#verify_admin"
    get 'admin/make-admin/:id', to: "users#make_admin"
    get 'admin/verify-agent/:id', to: "users#verify_agent"
    get 'admin/verified-agents', to: "admins#verified_agents"
    post 'admin/brands',  to: "admins#new_brand"
    post 'admin/banners',  to: "admins#new_banner"


    resources :transactions

    get 'subscribe/:id', to: 'subscriptions#subscriber'
    get 'my-subscription/:id', to: 'subscriptions#index'

    post 'promote/:id', to: 'promote#promoter'

    get 'subscribe-banner/:id', to: 'banner_ad_subscriber#subscriber'
    get 'subscribe-brand/:id', to: 'brand_subscriber#subscriber'

    resources :banner_ads, except: [:index]
    get 'banner_ads/users/:id', to: 'banner_ads#index'
    get 'brands/all', to: 'brands#brands'
    get 'brands/users/:id', to: 'brands#index'
    resources :brands, except: [:index]

    get 'markers/all', to: 'markers#index'
    resources :posts do
      resources :markers, except: [:index]
    end

    get 'forum/filter', to: "forums#filter"
    get 'forum/stats', to: "forums#stats"
    resources :forums do
      resources :comments
    end

    resources :contacts
    resources :verify_users
    
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
