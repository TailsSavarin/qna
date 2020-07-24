Rails.application.routes.draw do
  use_doorkeeper
  get 'rewards/index'
  get 'comments/create'
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :revote
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, concerns: %i[votable], shallow: true do
      member do
        post :choose_best
      end
      resources :comments
    end
    resources :comments
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show]
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  # mount ActionCable.server, at: '/cable'
end
