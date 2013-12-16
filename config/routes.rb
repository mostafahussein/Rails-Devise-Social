Comparendo::Application.routes.draw do


  devise_for :users, :controllers => {:sessions => 'sessions',:omniauth_callbacks => "users/omniauth_callbacks"  }

  namespace :admin do
    resources :company, :except => [:show]
    resources :articles
    resources :tags

    resources :events
    resources :leads
    resources :projects
    resources :messages

    root :to => 'events#index'
  end

  resources :contacts

  resources :company, :only => [:index, :show, :edit, :update] do
    put :update_cover_image, :on => :member
    collection do
      get :company_names
    end

    resources :images, :only => [:index, :create]
    resources :reviews, :only => [:create, :destroy]
  end

  resources :subcategories, :only => [:index]

  resources :images, :only => [:destroy]
  resources :reviews, :only => [:create, :destroy]
  resources :cities, :only => [] do
    get :name_autocomplete, :on => :collection
  end
  resources :regions, :only => [] do
    get :name_autocomplete, :on => :collection
  end
  resources :offer, :only => [:new, :create, :show]

  resources :users, :only => [] do
    collection do
      get :check_email
      get :profil
      put :profil
      get :company
      put :company 
      get :billing
      put :billing      
    end
  end

  # translated path
  match '/infos' => "article#overview"
  match '/infos/:path' => "article#show"
  match '/kontakt' => "contacts#new"
  match '/kontaktmail' => "contacts#create"
  match '/infos' => "devise/article#overview"

  match '/offerte-angefordert' => "offer#created", :as => 'offer_created'
  match '/offerte-anfordern(/:project_type_id)' => "offer#new", :as => 'new_offer'
  match '/offerte/:id' => "offer#show"

  match 'firma-eintragen/schritt-2' => "company#eintragen2", :as => 'company_add2'
  match 'firma-eintragen/schritt-3' => "company#eintragen3", :as => 'company_add3'
  match 'firma-eintragen/schritt-4' => "company#eintragen4", :as => 'company_add4'

  match 'firma-eintragen/abgeschlossen' => "company#finish", :as => 'company_add_finish'
  match 'firma-eintragen/abrechnung' => "company#payment", :as => 'company_payment'
  match 'firma-eintragen(/:id)' => "company#eintragen", :as => 'company_add'
  match 'architekten' => "company#index"

  resources :quotes, :only => [:edit, :update], :as => :projects
  post '/region-select' => "search#region_select", :as => :region_select
  post '/search' => "search#index", :as => :search
  post '/quote-details' => "quotes#new", :as => :quote_details
  post '/create-quote-details' => "quotes#create", :as => :create_quote_details
  
  get '/:region/:city/:company' => "company#show"

  get '/about' => "footer#about"  
  get '/jobs' => "footer#jobs"
  get '/privacy' => "footer#privacy"
  get '/terms' => "footer#terms"
  get '/sitemap' => "footer#sitemap"
  get '/impressum' => "footer#impressum"

  get "autocomplete/company_tag_article"
  get "autocomplete/company_tag"
  get "autocomplete/company_specialties"
  get "autocomplete/region_city"
  get "autocomplete/category_subcategory_synonym"
  root :to => 'home#index'

  match '*a', :to => 'errors#routing'
end
