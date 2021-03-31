Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :coffees
      get 'search', to: 'coffees#search'
    end
  end
end
