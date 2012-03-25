# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    unless @__user_initialized
      @__user = nil
      begin
        @__user = Sys::User.find(session[:user_id]) if session[:user_id] 
      rescue Exception => ex
      end
      @__user_initialized = true
    end
    @__user
  end

end
