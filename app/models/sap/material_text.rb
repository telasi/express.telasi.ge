# -*- encoding : utf-8 -*-
module Sap
  class MaterialText < Base
    self.table_name = "#{Express::Sap::SCHEMA}.MAKT"
    self.primary_keys = [:mandt, :matnr, :spras]
  end
end
