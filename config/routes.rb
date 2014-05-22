Rails.application.routes.draw do

  namespace :wow do
    get '/' => 'home#index', as: 'home'
    resources :auctions do
      collection do
        get :in_progress
        get :completed
      end
    end
    resources :realms
  end
end
