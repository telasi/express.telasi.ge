# -*- encoding : utf-8 -*-
module Sap
  class DriverInfo < Base
    self.table_name = "#{Express::Sap::SCHEMA}.ZMIGOHEADERADD"
    self.primary_keys = [:mandt, :mblnr, :mjahr]
  end
end
