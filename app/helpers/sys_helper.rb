# -*- encoding : utf-8 -*-
module SysHelper
  def roles(user)
    text = ''
    text += tooltiped_text('<span class="badge badge-error">ადმინი</span> ', 'სისტემური ადმინისტრატორი') if user.admin
    text += tooltiped_text('<span class="badge badge-success">საწყობი</span> ', 'საწყობის გამგე') if user.warehouse_admin
    text += tooltiped_text('<span class="badge badge-info">SAP</span> ', 'SAP-ის კონსულტანტი') if user.sap
    text.html_safe
  end
end
