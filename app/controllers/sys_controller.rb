# -*- encoding : utf-8 -*-
class SysController < ApplicationController
  before_filter :admin_permission_filter

  private

  def admin_permission_filter
    redirect_to(home_url, :notice => 'თქვენ არ გაქვთ ადმინისტრატორის უფლებები') if not current_user or not current_user.admin
  end
end
