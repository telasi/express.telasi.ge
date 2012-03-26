# -*- encoding : utf-8 -*-
module ApplicationHelper
  def current_user
    controller.current_user
  end
end