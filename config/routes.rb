Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    member do
      delete :delete_file
    end
    resources :answers, shallow: true, except: :index do
      member do
        post :choose_best
        delete :delete_file
      end
    end
  end
end
