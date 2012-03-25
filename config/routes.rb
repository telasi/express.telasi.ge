# -*- encoding : utf-8 -*-
ExpressTelasiGe::Application.routes.draw do
  get '/home', :controller => :site, :action => :index
  match '/login', :controller => :site, :action => :login
  get '/logout', :controller => :site, :action => :logout

  root :to => 'site#index'
end
