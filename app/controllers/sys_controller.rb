# -*- encoding : utf-8 -*-
class SysController < ApplicationController
  before_filter :admin_permission_filter

  protected

  def admin?
    true
  end

  def sap?
    false
  end

  private

  def admin_permission_filter
    if not current_user
      redirect_to(home_url, :alert => 'გაიარეთ ავტორიზაცია')
    elsif (not current_user.admin and admin?)
      redirect_to(home_url, :notice => 'თქვენ არ გაქვთ ადმინისტრატორის უფლებები')
    elsif not current_user.sap and sap?
      redirect_to(home_url, :notice => 'თქვენ არ გაქვთ SAP კონსულტანტის უფლებები')
    end
  end
end
