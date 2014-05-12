Rails.application.routes.draw do

  namespace :wow do
    get '/' => 'home#index', as: 'home'
    resources :auctions
    resources :realms
  end
end
