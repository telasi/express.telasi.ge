# -*- encoding : utf-8 -*-
module Sap
  class CostCenter < Base
    self.table_name = "#{Express::Sap::SCHEMA}.CSKT"
    self.primary_keys = [:mandt, :spras, :kokrs, :kostl, :datbi]
  end
end
