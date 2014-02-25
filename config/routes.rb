Shikechou::Application.routes.draw do
  get 'home/index'

  resources :teachers

  resources :universities

  resources :faculties

  resources :subjects
  #get 'filter/', to: 'subjects#filter', as: 'filter_subjects'
  get 'subjects/:id/notes/', to: 'subjects#notes', as: 'notes_in_show_subject'
    
  resources :notes
  get 'notes/download/:id', to: 'notes#download', as: 'download'
  get 'notes/delete/:id', to: 'notes#delete_document', as: 'delete_document'
  #get 'notes/filter/:type', to: 'notes#filter', as: 'filter_notes'

  resources :documents

  resources :users
  get "/faculty" => "users#faculty"

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  controller :schedule do
    post 'schedule/new' => :create, as: 'create_schedule'
    put 'schedule/new/:id' => :update
  end
  get 'schedule/destroy'
  get 'schedule/index' => 'schedule#index', as: :schedule
  get 'schedule/edit'
  get 'schedule/new'
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
