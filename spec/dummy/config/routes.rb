
Rails.application.routes.draw do
  mount TempletRails::Engine, at: '/templet'

  resources(:categories) { resources :questions }

  resources(:questions, only: []) { resources :answers }
end

