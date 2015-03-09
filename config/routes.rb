Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :stores
    resources :homepage_slides
    resources :homepages do
      collection do
        get 'search', to: 'homepages#search'
      end
      member do
        get 'products', to: 'homepages#products'
      end
    end
  end

  resources :stores, only: [:index, :show], path: 's'
  get '/stores/:id', to: redirect('/s/%{id}')

  namespace :api, :defaults => { :format => 'json' } do
    resources :stores, only: [:index, :show]
    resources :homepage_products do
      collection do
        put 'update', to: 'homepage_products#update'
      end
    end
  end

  get 'products/ga/:id', to: 'products#analytics_click'

end
