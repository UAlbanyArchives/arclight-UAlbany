Rails.application.routes.draw do

  scope 'description' do

   concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
    mount Blacklight::Engine => '/'
      mount Arclight::Engine => '/'

    root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

    resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
      concerns :searchable
      concerns :range_searchable

    end
    devise_for :users
    concern :exportable, Blacklight::Routes::Exportable.new

    resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
      concerns :exportable
    end

    resources :bookmarks do
      concerns :exportable

      collection do
        delete 'clear'
      end
    end

  end

  # For docker healthcheck
  get 'health', to: proc { [200, {}, ['OK']] }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
