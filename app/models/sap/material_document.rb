# -*- encoding : utf-8 -*-
require 'rs'

module Sap
  class MaterialDocument < Base
    self.table_name   = "#{Express::Sap::SCHEMA}.MKPF"
    self.primary_keys = [:mandt, :mblnr, :mjahr]

    has_many :items, :class_name => 'Sap::MaterialItem', :foreign_key => [:mandt, :mblnr, :mjahr]
    has_one :driver_info, :class_name => 'Sap::DriverInfo', :foreign_key => [:mandt, :mblnr, :mjahr]

    self.date_fields :bldat, :budat

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

    def waybill_document?
      self.inner? # or self.sale? # or self.purchase? or self.return? -- XXXX
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

      if self.driver_info
        waybill.car_number = self.driver_info.vehicle
        waybill.transport_type_id = RS::TransportType::VEHICLE
        waybill.driver_name = self.driver_info.driver
        waybill.driver_tin = self.driver_info.drperno
        waybill.check_driver_tin  = true
        waybill.seller_info = self.driver_info.name
        waybill.buyer_info = self.driver_info.namepo
      end

      # start/end address
      if self.return?
        address1 = not_auto.warehouse_address if not_auto
        address2 = auto.warehouse_address if auto
      else
        address1 = not_auto.warehouse_address if not_auto
        address2 = not_auto.invoice_address if not_auto
      end
      waybill.start_address = address1.address.to_s if address1
      waybill.end_address = address2.address.to_s if address2

      # items
      items = []
      self.items.each do |doc_item|
        item = RS::WaybillItem.new
        item.bar_code = doc_item.matnr.match(/[1-9][0-9]*/)[0]
        item.prod_name = doc_item.material_name_ka.maktx
        item.unit_id = RS::WaybillUnit::OTHERS
        item.unit_name = doc_item.meins
        item.quantity = doc_item.menge
        item.price = doc_item.dmbtr / item.quantity
        items << item
      end
      waybill.items = items

      waybill
    end
  end
end
