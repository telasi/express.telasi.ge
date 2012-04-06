# -*- encoding : utf-8 -*-
class SysController < ApplicationController
  def auth?
    Sys::User.count > 0
  end

  def admin?
    true
  end
end
