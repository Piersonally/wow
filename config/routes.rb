Rails.application.routes.draw do

  namespace :wow do
    resources :auctions
    resources :realms
  end
end
