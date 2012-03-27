# -*- encoding : utf-8 -*-
module Sap
  class WarehouseAddress < Base
    self.table_name = "#{Express::Sap::SCHEMA}.TWLAD"
    self.primary_keys = [:mandt, :werks, :lgort, :lfdnr]
    belongs_to :address, :class_name => 'Sap::Address', :foreign_key => :adrnr, :conditions => ['LANGU = ? AND CLIENT = ?', Express::Sap::LANG_KA, Express::Sap::MANDT]
  end
end
