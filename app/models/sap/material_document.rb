# -*- encoding : utf-8 -*-
module Sap
  class MaterialDocument < Base
    self.table_name   = "#{Express::Sap::SCHEMA}.MKPF"
    self.primary_keys = [:mandt, :mblnr, :mjahr]

    has_many :items, :class_name => 'Sap::MaterialItem', :foreign_key => [:mandt, :mblnr, :mjahr]
    has_one :driver_info, :class_name => 'Sap::DriverInfo', :foreign_key => [:mandt, :mblnr, :mjahr]

    self.date_fields :bldat, :budat
  end
end
