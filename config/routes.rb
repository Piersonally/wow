Rails.application.routes.draw do

  namespace :wow do
    resources :realms
  end
end
