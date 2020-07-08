Rails.application.routes.draw do
  get 'rewards/index'
  root 'questions#index'

  devise_for :users

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :revote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :choose_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index

  # mount ActionCable.server, at: '/cable'
end
