# -*- encoding : utf-8 -*-
ExpressTelasiGe::Application.routes.draw do
  get '/home', :controller => :site, :action => :index

  root :to => 'site#index'
end
