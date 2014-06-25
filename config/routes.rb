Rails.application.routes.draw do

  namespace :wow do
    get '/' => 'home#index', as: 'home'
    resources :auctions do
      collection do
        get :in_progress
        get :sold
        get :expired
      end
    end
    resources :realms
    resources :items, only: [:index, :show] do
      collection do
        get :search
      end
    end
  end
end
