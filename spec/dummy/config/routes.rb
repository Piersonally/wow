Rails.application.routes.draw do

  devise_for :users
  mount Wow::Engine => "/wow"
end
