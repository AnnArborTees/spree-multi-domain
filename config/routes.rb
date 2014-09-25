Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :stores
  end
  get 'stores', to: 'stores#index'
  get 'stores/*store_codes', to: 'stores#show'

  namespace :api, :defaults => { :format => 'json' } do
    resources :stores
  end

end
