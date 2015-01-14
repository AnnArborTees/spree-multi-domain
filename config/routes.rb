Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :stores
    resources :homepage_slides
    resources :homepages
  end

  resources :stores, only: [:index, :show], path: 's'
  get '/stores/:id', to: redirect('/s/%{id}')

  namespace :api, :defaults => { :format => 'json' } do
    resources :stores, only: [:index, :show]
  end

end
