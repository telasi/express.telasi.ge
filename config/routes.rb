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
    scope 'roles', :controller => :roles do
      get '/',              :action => :index,  :as => :roles
      match '/new',         :action => :new,    :as => :new_role
      match '/edit/:id',    :action => :edit,   :as => :edit_role
      get '/show/:id',      :action => :show,   :as => :show_role
      delete '/delete/:id', :action => :delete, :as => :delete_role
    end
  end

  root :to => 'site#index'
end
