
Rails.application.routes.draw do
  resources(:categories) { resources :questions }

  resources(:questions, only: []) { resources :answers }
end

