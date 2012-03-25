# -*- encoding : utf-8 -*-
ExpressTelasiGe::Application.routes.draw do
  get '/home', :controller => :site, :action => :index
  match '/login', :controller => :site, :action => :login
  get '/logout', :controller => :site, :action => :logout

  namespace 'sys' do
    scope 'users', :controller => :users do
      get '/', :action => :index, :as => :users
      match '/new', :action => :new, :as => :new_user
      match '/edit/:id', :action => :edit, :as => :edit_user
      delete '/delete/:id', :action => :delete, :as => :delete_user
    end
  end

  root :to => 'site#index'
end
