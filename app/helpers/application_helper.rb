# -*- encoding : utf-8 -*-
module ApplicationHelper
  def current_user
    controller.current_user
  end

  def paginate(items)
    will_paginate items, :previous_label => '&larr;', :next_label => '&rarr;'
  end
end
