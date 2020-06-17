Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true, except: :index do
      member do
        post :choose_best
      end
    end
  end
  
  resources :attachments, only: :destroy
end
