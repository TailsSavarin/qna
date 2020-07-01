Rails.application.routes.draw do
  get 'rewards/index'
  root 'questions#index'

  devise_for :users

  resources :questions do
    member do
      post :vote_up
      post :vote_down
    end
    resources :answers, shallow: true, except: :index do
      member do
        post :choose_best
      end
    end
  end
  
  resources :attachments, only: :destroy
  resources :rewards, only: :index
end
