# -*- encoding : utf-8 -*-
class SysController < ApplicationController
  def auth?
    true
  end

  def admin?
    true
  end
end
