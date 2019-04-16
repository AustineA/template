Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  
  defaults format: 'json' do
    resources :users, only: [:create, :update, :index, :show]
    get 'agents/:id/', to: 'users#agents'
    get 'agents/:id/purpose', to: 'users#purpose'

    resources :posts
    resources :posts, :path=> '', except: [:index]
    get 'q/search', to: 'posts#search'


    root 'posts#index'
  end
end
