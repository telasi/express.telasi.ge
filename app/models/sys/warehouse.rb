# -*- encoding : utf-8 -*-
module Sys
  class Warehouse
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, type: String
    field :address, type: String
    field :werks
    field :lgort

    index :name
    index [[:werks, Mongo::ASCENDING], [:lgort, Mongo::ASCENDING]]

    def sap_warehouse
      Sap::Warehouse.where(:mandt => Express::Sap::MANDT, :werks => self.werks, :lgort => self.lgort).first
    end
  end
end
