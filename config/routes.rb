Shikechou::Application.routes.draw do
  get 'home/index'

  resources :teachers

  resources :universities, shallow: true do
    resources :faculties do
      resources :courses
    end
  end

  resources :subjects
  get 'semester' => 'subjects#semester'
  put 'subjects/:id/inline' => 'subjects#inline'
  get 'subjects/:id/version/:version_id' => 'subjects#version', as: 'version'
    
  resources :notes
  #get 'notes/filter/:type', to: 'notes#filter', as: 'filter_notes'
  get 'tags' => 'notes#tags'
  get 'notes/:id/documents' => 'notes#documents'

  resources :documents
  patch 'documents' => 'documents#create'

  resources :users
  get 'faculty' => 'users#faculty'
  get 'course' => 'users#course'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  controller :schedule do
  end
  delete 'schedule' => 'schedule#destroy', as: 'schedule_destroy'
  get 'schedule/index' => 'schedule#index', as: :schedule
  post 'schedule' => 'schedule#create', as: 'schedule_create'
  
  resources :schedule
    
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'home/index' => 'home#index', as: :home
  
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
