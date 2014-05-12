Rails.application.routes.draw do

  namespace :wow do
    get '/' => 'home#index'
    resources :auctions
    resources :realms
  end
end
