Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  
  defaults format: 'json' do
    resources :users, only: [:create, :update, :index, :show]

    resources :posts
    resources :posts, :path=> '', except: [:index]

    root 'posts#index'
  end
end
