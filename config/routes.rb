# -*- encoding : utf-8 -*-
ExpressTelasiGe::Application.routes.draw do
  get '/home', :controller => :site, :action => :index
  match '/login', :controller => :site, :action => :login
  get '/logout', :controller => :site, :action => :logout

  namespace 'sys' do
    scope 'users' do
      get '/', :action => :index, :controller => :users, :as => :users
      match '/new', :action => :new, :controller => :users, :as => :new_user
      match '/edit/:id', :action => :edit, :controller => :users, :as => :edit_user
      delete '/delete/:id', :action => :delete, :controller => :users, :as => :delete_user
    end
  end

  root :to => 'site#index'
end
