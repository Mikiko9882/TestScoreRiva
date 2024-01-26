Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  get 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create index show] do
  end
  
  resources :test_results do
  end

  resource :profile, only: %i[show edit update] 
end
