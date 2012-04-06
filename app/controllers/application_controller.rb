# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authentication_filter

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

  def auth?
    false
  end

  def admin?
    false
  end

  def sap?
    false
  end

  def warehouse_admin?
    false
  end

  def no_role?
    false
  end

  private

  def authentication_filter
    if not auth?
      # ok
    elsif auth? and current_user.nil?
      redirect_to home_url, :notice => 'გაიარეთ ავტორიზაცია'
    elsif auth? and admin? and current_user.admin
      # ok
    elsif auth? and sap?   and current_user.sap
      # ok
    elsif auth? and warehouse_admin? and current_user.warehouse_admin
      # ok
    elsif auth? and no_role?
      # ok
    else
      redirect_to home_url, :notice => 'არ გაქვთ შესაბამისი უფლება'
    end
  end

end
