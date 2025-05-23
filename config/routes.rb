Rails.application.routes.draw do
  scope 'description' do
    mount Blacklight::Engine => '/'
    mount BlacklightDynamicSitemap::Engine => '/'

    mount Arclight::Engine => '/'

    get '/', to: 'arclight/repositories#home', as: 'home'

    root to: "arclight/repositories#index"
    concern :searchable, Blacklight::Routes::Searchable.new

    resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
      concerns :searchable
    end
    devise_for :users

    concern :exportable, Blacklight::Routes::Exportable.new
    concern :hierarchy, Arclight::Routes::Hierarchy.new

    resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :hierarchy
      concerns :exportable
    end

    resources :bookmarks do
      concerns :exportable

      collection do
        delete 'clear'
        get 'clear', to: 'bookmarks#clear'
      end
    end
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Render dynamic PWA files from app/views/pwa/*
    get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

    # Defines the root path route ("/")
    # root "posts#index"

    # For docker healthcheck
    get 'health', to: proc { [200, {}, ['OK']] }

    # I had to add this, as for some reason BL8.4 is sending get requests for it?
    get 'search_history/clear', to: 'search_history#clear'
  end
end
