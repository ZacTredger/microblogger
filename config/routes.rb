Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/help'    => 'static_pages#help'
  get    '/about'   => 'static_pages#about'
  get    '/contact' => 'static_pages#contact'
  get    '/signup'  => 'users#new'
  post   '/signup'  => 'users#create'
  get    '/login'   => 'sessions#new'
  post   '/login'   => 'sessions#create'
  delete '/logout'  => 'sessions#destroy'
  resources :users do
    member do
      get :followers, :following
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     except: %i[index destroy show]
  resources :posts,               only: %i[create destroy]
  resources :relationships,       only: %i[create destroy]
end
