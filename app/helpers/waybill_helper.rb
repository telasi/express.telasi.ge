# -*- encoding : utf-8 -*-
module WaybillHelper
  def waybill_class(doc)
    if (doc.rs_sent? or doc.rs_closed?) and doc.storno
      'storno'
    elsif doc.rs_sent?
      'sent'
    elsif doc.rs_closed?
      'closed'
    else
      'common'
    end
  end
end