Shikechou::Application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users, skip: [:session, :password, :registration], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  #using i18n, scope locale with url path: /en/
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    #devise routes
    devise_for :users, skip: [:omniauth_callbacks],
      controllers: {sessions: "users/sessions", registrations: 'users/registrations', confirmations: 'users/confirmations', passwords: 'users/passwords'}, 
      path_names: {sign_in: 'login', sign_out: 'logout'}
      
    resources :teachers
  
    resources :universities do
      # reload teachers list in edit page
      get 'reload' => 'universities#reload', on: :member
    end
    # special url for uni info page, will handler no id param passed as current_university
    get 'information' => 'universities#show', as: :uni_information
    #university will be used as subdomain. so faculty should not be nested inside university
    
    resources :faculties, shallow: true do
      resources :courses do
      end
    end
    
    resources :subjects do
      #edit inline feature, in subject edit 
      put 'inline' => 'subjects#inline', on: :member # on: :member will take :id not :subject_id, and path as inline_subject_path
      
      #change number of outlines, in form
      get 'outline' => 'subjects#outline', on: :member
      
      #tags, periods, new_auto in subject edit, subject new
      get 'tags' => 'subjects#tags', on: :member
      get 'periods' => 'subjects#periods', on: :member
      post 'new_auto' => 'subjects#new_auto', on: :member
      
      # need to reload 1 subject when register btn clicked.
      get 'reload/:id' => 'subjects#reload', on: :collection
    end
      
    resources :notes do
      #get existed documents for note
      get 'documents' => 'notes#documents', on: :member
      get 'tags' => 'notes#tags', on: :member
      post 'like' => 'notes#like', on: :member
      post 'dislike' => 'notes#dislike', on: :member
      post 'star' => 'notes#star', on: :member
    end
    
    #get tags.json
    get 'tags' => 'application#tags'
    #get faculties data
    #use faculties_list instead of faculties
    get 'faculties_list' => 'application#faculties'
    #get courses data
    get 'courses' => 'application#courses'
    #get uni_year data
    get 'uni_years' => 'application#uni_years'
    #get semester data
    get 'semesters' => 'application#semesters'
    
    # notifications
    get 'read' => 'activities#read'
    get 'notification_count' => 'activities#notification_count'
    get 'mark_as_read_all' => 'activities#mark_as_read_all'
    get 'refresh_notification_count' => 'activities#refresh_notification_count'
    get 'refresh_notification_list' => 'activities#refresh_notification_list'
  
    resources :users do
      resources :educations do
        post '/new_auto' => 'educations#new_auto', on: :collection
      end
    end
    # special url for profile, will handler no id param passed as current_user
    get 'profile' => 'users#show', as: :profile
    
    # there is only one schedule, no schedules
    # so the routes will be a bit difference
    controller :schedule do
      delete 'schedule' => :destroy, as: 'schedule_destroy'
      get 'schedule/index' => :index
      get 'schedule' => :index, as: :schedule
      post 'schedule' => :create, as: 'schedule_create'
      get 'schedule/view_option' => 'schedule#view_option' # change style of table: week <-> day
    end
    
    resources :requests
      
    # new and edit document process is handled in note page
    resources :documents, except: [:new, :edit] do
      put 'inline' => 'documents#inline', on: :collection
      resources :comments, except: [:new]
    end
    
    # routes for search in header
    get 'search' => 'search#search', as: 'search'
      
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
  
    # You can have the root of your site routed with "root"
    # root 'welcome#index'
    
    # url with subdomain will be redirected to home page
    get '', to: 'home#index', constraints: {subdomain: /.+/}
    root 'home#index'
    get 'home/index' => 'home#index', as: :home
  
    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'
  
    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
    
    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products
  
    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end
  
    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end
  
    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end
  
    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable
  
    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
  end
  # default locale
  #match '*path', to: redirect('/#{I18n.default_locale}/%{path}'), via: [:get, :post]
  #match '', to: redirect('/#{I18n.default_locale}'), via: [:get, :post]
     
end
