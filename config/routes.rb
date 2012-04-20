# -*- encoding : utf-8 -*-
ExpressTelasiGe::Application.routes.draw do
  get '/home', :controller => :site, :action => :index
  match '/login', :controller => :site, :action => :login
  get '/logout', :controller => :site, :action => :logout
  match '/account', :controller => :site, :action => :account
  match '/password', :controller => :site, :action => :password

  namespace 'sys' do
    scope 'users', :controller => :users do
      get '/',              :action => :index,  :as => :users
      match '/new',         :action => :new,    :as => :new_user
      match '/edit/:id',    :action => :edit,   :as => :edit_user
      get '/show/:id',      :action => :show,   :as => :show_user
      delete '/delete/:id', :action => :delete, :as => :delete_user
    end
    scope 'warehouse', :controller => :warehouse do
      get    '/',         :action => :index, :as => :warehouses
      match  '/new',      :action => :new,   :as => :new_warehouse
      post   '/sync',     :action => :sync,  :as => :sync_warehouses
      get    '/show/:id', :action => :show,  :as => :show_warehouse
      post   '/add_user/:id', :action => :add_user, :as => :add_warehouse_user
    end
  end

  namespace 'sap' do
    scope 'waybills', :controller => :waybills do
      get '/',                :action => :index,      :as => :waybills
      post '/sync',           :action => :sync,       :as => :sync_waybills
      get  '/show/:id',       :action => :show,       :as => :show_waybill
      post '/send_to_rs/:id', :action => :send_to_rs, :as => :send_to_rs
      post '/sync_rs/:id',    :action => :sync_rs,    :as => :sync_rs 
      post '/cancel_rs/:id',  :action => :cancel_rs,  :as => :cancel_rs
      post '/close_rs/:id',   :action => :close_rs,   :as => :close_rs
      get '/monitor',         :action => :monitor,    :as => :monitor
    end
  end

  root :to => 'site#index'
end
