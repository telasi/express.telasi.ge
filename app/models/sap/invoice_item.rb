# -*- encoding : utf-8 -*-
module Sap
  class InvoiceItem < Base
    self.table_name = "#{Express::Sap::SCHEMA}.EKPO"
    self.primary_keys = [:mandt, :ebeln, :ebelp]
  end
end
