# -*- encoding : utf-8 -*-
module Sap
  class MaterialItem < Base
    self.table_name   = "#{Express::Sap::SCHEMA}.MSEG"
    self.primary_keys = [:mandt, :mblnr, :mjahr, :zeile]

    def material_name_ka
      Sap::MaterialText.where(:mandt => self.mandt, :matnr => self.matnr, :spras => Express::Sap::LANG_KA).first
    end

    # საწყობის მისამართი (გასვლა).
    def warehouse_address
      Sap::WarehouseAddress.where(:werks => self.werks, :lgort => self.lgort).first
    end

    # შესყიდვის მისამართი (დანიშნულება).
    def invoice_address
      item = Sap::InvoiceItem.where(:ebeln => self.ebeln).first
      Sap::WarehouseAddress.where(:werks => item.werks, :lgort => item.lgort).first if item
    end

    # არის თუ არა ეს პოზიცია დაგენერირებული ავტომატურად?
    def auto?
      self.xauto.upcase == 'X'
    end
  end
end