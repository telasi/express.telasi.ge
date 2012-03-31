# -*- encoding : utf-8 -*-
require 'rs'

module Sap
  module Ext
    class MaterialDocument
      include Mongoid::Document
      include Mongoid::Timestamps

      TYPE_PURCHASE = 1
      TYPE_INNER    = 2
      #TYPE_RETURN   = 3
      TYPE_SALE     = 4

      field :mblnr,     type: String
      field :mjahr,     type: Integer
      field :date,      type: Date
      field :type,      type: Integer
      field :rs_id,     type: Integer
      field :rs_number, type: String
      field :rs_status, type: Integer, default: RS::Waybill::STATUS_SAVED
      field :rs_start,  type: Date
      field :rs_end,    type: Date
      belongs_to :warehouse, :class_name => 'Sys::Warehouse'

      index [[:mblnr, Mongo::ASCENDING], [:mjahr, Mongo::ASCENDING]]
      index :date

      def sap_doc
        Sap::MaterialDocument.where(:mblnr => self.mblnr, :mjahr => self.mjahr, :mandt => Express::Sap::MANDT).first
      end

      def type_icon
        case self.type
        when TYPE_PURCHASE
          'shopping-cart'
        when TYPE_INNER
          'refresh'
        #when TYPE_RETURN
        #  'repeat'
        when TYPE_SALE
          'share-alt'
        end
      end

      def type_text
        case self.type
        when TYPE_PURCHASE
          'შესყიდვა'
        when TYPE_INNER
          'შიდა'
        #when TYPE_RETURN
        #  'დაბრუნება'
        when TYPE_SALE
          'გაყიდვა'
        end
      end

      def rs_status_icon
        case self.rs_status
        when RS::Waybill::STATUS_ACTIVE
          'road'
        when RS::Waybill::STATUS_CLOSED
          'ok-sign'
        else
          'map-marker'
        end
      end

      def rs_status_text
        case self.rs_status
        when RS::Waybill::STATUS_ACTIVE
          'აქტივირებული'
        when RS::Waybill::STATUS_CLOSED
          'დასრულებული'
        else
          'წინასწარი'
        end
      end
    end
  end
end
