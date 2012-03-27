# -*- encoding : utf-8 -*-
module Sap
  class Warehouse < Base
    self.table_name   = "#{Express::Sap::SCHEMA}.T001L"
    self.primary_keys = [:mandt, :lgort, :werks]

    def addresses
      Sap::WarehouseAddress.where(:mandt => self.mandt, :werks => self.werks, :lgort => self.lgort)
    end
  end
end
