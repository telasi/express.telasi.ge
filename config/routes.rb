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
      get    '/',           :action => :index,  :as => :warehouses
      match  '/new',        :action => :new,    :as => :new_warehouse
      match  '/edit/:id',   :action => :edit,   :as => :edit_warehouse
      get    '/show/:id',   :action => :show,   :as => :show_warehouse
      delete '/delete/:id', :action => :delete, :as => :delete_warehouse
    end
  end

  root :to => 'site#index'
end
