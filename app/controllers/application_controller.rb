# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  DATE_FORMAT = '%d-%b-%Y'

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

  def current_param(class_name, name, def_val = nil)
    @__curr_hash = @__curr_hash || {}
    unless @__curr_hash.include?(name)
      if params[name]
        @__curr_hash[name] = params[name]
        Sys::Preference.set(current_user, "#{class_name}_#{name}", params[name])
      else
        txt = Sys::Preference.get(current_user, "#{class_name}_#{name}")
        if txt and not txt.strip.empty?
          @__curr_hash[name] = txt
        else
          @__curr_hash[name] = def_val
        end
      end
    end
    @__curr_hash[name]
  end
end
