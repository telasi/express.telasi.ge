# -*- encoding : utf-8 -*-
module Sap
  class Address < Base
    self.table_name = "#{Express::Sap::SCHEMA}.ADRC"
    self.primary_keys = :addrnumber

    def cost_center
      Sap::CostCenter.where(:spras => Express::Sap::LANG_KA, :mandt => Express::Sap::MANDT, :kokrs => Express::Sap::KOKRS, :kostl => self.floor).first
    end

    def to_s
      [self.city1, self.street].compact.join(' ').strip
    end
  end
end
