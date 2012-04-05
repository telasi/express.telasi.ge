# -*- encoding : utf-8 -*-
module Sap
  class AddressText < Base
    self.table_name = "#{Express::Sap::SCHEMA}.ADRCT"
    self.primary_keys = [:client, :addrnumber, :date_from, :nation, :langu]
  end
end
