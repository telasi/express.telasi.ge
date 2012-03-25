# -*- encoding : utf-8 -*-
module BootstrapHelper
  def bootstrap_alert(opts = {}, &block)
    %Q{<div class="alert alert-#{opts[:class] || 'warning'} fade in">
      <a class="close" data-dismiss="alert" href="#">&times;</a>
      #{ capture(&block) }
      </div>}.html_safe
  end

  def icon_text(icn, txt = nil, opts = {})
    icon_name = "icon-#{icn}"
    icon_name += " icon-white" if opts[:white] 
    tooltip = opts[:tooltip] ? %Q{rel="tooltip" data-original-title="#{opts[:tooltip]}"} : nil
    %Q{<span #{tooltip}><i class="#{icon_name}"></i> #{txt}</span>}.strip.html_safe
  end
end