# -*- encoding : utf-8 -*-
module Sap
  class Warehouse
    self.table_name   = "#{Express::Sap::SCHEMA}.MKPF"
    self.primary_keys = [:mandt, :lgort, :werks]
  end
end
