# -*- encoding : utf-8 -*-
require 'rs'

module Sap
  class MaterialDocument < Base
    self.table_name   = "#{Express::Sap::SCHEMA}.MKPF"
    self.primary_keys = [:mandt, :mblnr, :mjahr]

    has_many :items, :class_name => 'Sap::MaterialItem', :foreign_key => [:mandt, :mblnr, :mjahr]
    has_one :driver_info, :class_name => 'Sap::DriverInfo', :foreign_key => [:mandt, :mblnr, :mjahr]

    self.date_fields :bldat, :budat

    def main_items
      self.items.find_all {|item| item.shkzg == 'H' }
    end

    def purchase?
      item = self.items.first
      (item.ebeln[0..1] == '45' and item.bwart == '101') or item.bwart == '301'
    end

    def inner?
      item = self.items.first
      (item.ebeln[0..1] == '49' and item.bwart == '351') or self.return?
    end

    def return?
      item = self.items.first
      item.bwart == '301' or item.bwart == '311'
    end

    def sale?
      item = self.items.first
      item.bwart = '983'
    end

    def storno?
      not Sap::MaterialItem.where(:smbln => self.mblnr, :mandt => self.mandt).all.empty?
    end

    def waybill_document?
      item = self.items.first
      self.inner? and self.driver_info.doc_type != '3' and item.werks != '1300' # or self.sale? # or self.purchase? or self.return? -- XXXX
    end

    def to_waybill
      waybill = RS::Waybill.new

      not_auto = nil
      auto = nil
      self.items.each do |item|
        if item.auto?
          auto = item
        else
          not_auto = item
        end
        auto and not_auto unless item.auto?
      end

      if self.inner?
        waybill.type            = RS::WaybillType::INNER
        waybill.seller_id       = Express::TELASI_PAYER_ID
        waybill.seller_tin      = Express::TELASI_TIN
        waybill.seller_name     = Express::TELASI_NAME
        waybill.check_buyer_tin = true
        waybill.buyer_tin       = Express::TELASI_TIN
        waybill.buyer_name      = Express::TELASI_NAME
      else
        raise RuntimeError.new("not supported")
      end

      # საწყისი და საბოლოო მისამართის განსაზღვრა
      if self.return?
        address1 = not_auto.warehouse_address if not_auto
        address2 = auto.warehouse_address if auto
      else
        address1 = not_auto.warehouse_address if not_auto
        address2 = not_auto.invoice_address if not_auto
      end
      waybill.start_address = address1.address.to_s if address1
      waybill.end_address = address2.address.to_s if address2

      # ტრანსპორტირების პარამეტრების განსაზღვრა
      if self.driver_info
        waybill.seller_info = self.driver_info.name
        waybill.buyer_info = self.driver_info.namepo
        waybill.car_number = self.driver_info.vehicle
        if waybill.car_number and not waybill.car_number.strip.empty?
          waybill.transport_type_id = RS::TransportType::VEHICLE
          waybill.driver_name = self.driver_info.driver
          waybill.driver_tin = self.driver_info.drperno
          waybill.check_driver_tin  = true
        #elsif waybill.start_address == waybill.end_address
        #  waybill.type = RS::WaybillType::WITHOUT_TRANSPORTATION
        else
          waybill.transport_type_id = RS::TransportType::OTHERS
          waybill.transport_type_name = 'თვითგადაზიდვა'
        end
      end

      # items
      items = []
      self.main_items.each do |doc_item|
        item = RS::WaybillItem.new
        item.bar_code = doc_item.matnr.match(/[1-9][0-9]*/)[0]
        item.prod_name = doc_item.material_name_ka.maktx
        item.unit_id = RS::WaybillUnit::OTHERS
        unit = doc_item.unit
        item.unit_name = unit ? unit.mseht : '?'
        item.quantity = doc_item.menge
        item.price = 0 #doc_item.dmbtr / item.quantity
        items << item
      end
      waybill.items = items

      waybill
    end
  end
end
