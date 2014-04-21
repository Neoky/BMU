BMU::Application.routes.draw do

  get 'test', to: 'test#index'
  get 'test/credit_rate', to: 'test#credit_rate'
  get 'test/market_rate', to: 'test#market_rate'
  get 'test/saving_rate', to: 'test#saving_rate'
  get 'test/bill_pay', to: 'test#bill_pay'
  get 'test/mortgages_behind', to: 'test#mortgages_behind'

  get 'bills/start/:id', to: 'bills#enable', as: 'start_recurrence'
  get 'bills/stop/:id', to: 'bills#disable', as: 'stop_recurrence'
  get 'bills/new', to: 'bills#new', as: 'new_bill'
  get 'bills/new/:id', to: 'bills#new', as: 'bill_by_id'
  post 'bills/create', to: 'bills#create', as: 'bills'
  resources :bills, :only => [:edit, :show, :update, :destroy]

  resources :accounts, :only => [:show, :destroy]
  get 'accounts', to: 'accounts#index'
  post 'accounts', to: 'accounts#index'
  get 'accounts/enable/:id', to: 'accounts#enable', as: 'enable_account'
  get 'accounts/disable/:id', to: 'accounts#disable', as: 'disable_account'
  resources :savings, :only => [:new, :create, :edit, :update]
  resources :checkings, :only => [:new, :create, :edit, :update]
  resources :mortgages, :only => [:new, :create, :edit, :update]
  resources :credits, :only => [:new, :create, :edit, :update]
  resources :markets, :only => [:new, :create, :edit, :update]

  #transactions
  get 'transactions', to: 'transactions#index', as: 'transactions'

  get 'transfers/new', to: 'transfers#new', as: 'new_transfer'
  get 'transfers/new/:id', to: 'transfers#new', as: 'transfer_by_id'
  post 'transfers/create', to: 'transfers#create', as: 'transfers'

  get 'withdrawals/new', to: 'withdrawals#new', as: 'new_withdrawal'
  get 'withdrawals/new/:id', to: 'withdrawals#new', as: 'withdraw_by_id'
  post 'withdrawals/create', to: 'withdrawals#create', as: 'withdrawals'

  get 'deposits/new', to: 'deposits#new', as: 'new_deposit'
  get 'deposits/new/:id', to: 'deposits#new', as: 'deposit_by_id'
  post 'deposits/create', to: 'deposits#create', as: 'deposits'


  get "users", to: 'user#index', as: 'users'
  post "users", to: 'user#index'
  get "teller", to: 'teller#index', as: 'teller_panel'
  #get "administrator/index"
  get 'administrator', to: 'administrator#index', as: 'admin_panel'
  get "customer/:id", to: 'customer#index', as: 'customer_by_id'
  get "customer/", to: 'customer#index', as: 'customer'

  #get "home/index"
  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => "sessions"}
  devise_scope :user do
    post 'registrations/sign_up', to: 'registrations#create', as: 'new_registration'
  end

  #post 'users/sign_up', to: 'registrations#create'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => 'home#index'

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
