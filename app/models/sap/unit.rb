# -*- encoding : utf-8 -*-
module Sap
  class Unit < Base
    self.table_name = "#{Express::Sap::SCHEMA}.T006A"
    self.primary_keys = [:mandt, :spras, :msehi]
  end
end