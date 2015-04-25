Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :offers, only: [:index] do
    collection do
      post "fetch"
    end
  end
end
