Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :stores
    resources :homepage_slides
  end
  get 'stores', to: 'stores#index'
  get 'stores/*store_codes', to: 'stores#show'

  namespace :api, :defaults => { :format => 'json' } do
    resources :stores, only: [:index, :show]
  end

end
