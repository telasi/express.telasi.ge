# -*- encoding : utf-8 -*-
module Sap
  module Ext
    class MaterialDocument
      include Mongoid::Document
      include Mongoid::Timestamps

      TYPE_PURCHASE = 1
      TYPE_INNER    = 2
      TYPE_RETURN   = 3
      TYPE_SALE     = 4

      field :mblnr, type: String
      field :mjahr, type: Integer
      field :date,  type: Date
      field :type,  type: Integer

      index [[:mblnr, Mongo::ASCENDING], [:mjahr, Mongo::ASCENDING]]
      index :date
    end
  end
end
