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
      field :storno,    type: Boolean
      field :rs_id,     type: Integer
      field :rs_number, type: String
      field :rs_status, type: Integer, default: RS::Waybill::STATUS_SAVED
      field :rs_start,  type: Time
      field :rs_end,    type: Time
      belongs_to              :warehouse, :class_name => 'Sys::Warehouse'
      has_and_belongs_to_many :users,     :class_name => 'Sys::User'

      index [[:mblnr, Mongo::ASCENDING], [:mjahr, Mongo::ASCENDING]]
      index :date

      def self.by_user(user)
        if user.sap or user.warehouse_admin
          where
        else
          all_in(user_ids: [user.id])
        end
      end

      def sap_doc
        Sap::MaterialDocument.where(:mblnr => self.mblnr, :mjahr => self.mjahr, :mandt => Express::Sap::MANDT).first
      end

      def rs_sent?
        self.rs_id and self.rs_status == RS::Waybill::STATUS_ACTIVE
      end

      def rs_closed?
        self.rs_id and self.rs_status == RS::Waybill::STATUS_CLOSED
      end

      def rs_canceled?
        self.rs_id and self.rs_status == RS::Waybill::STATUS_DEACTIVATED
      end

      def sync_waybill!(waybill_id = nil)
        id = waybill_id || self.rs_id
        wb = RS.get_waybill('waybill_id' => id, 'su' => Express::SU, 'sp' => Express::SP) if id
        if wb.nil? #or (wb.status == RS::Waybill::STATUS_DELETED or wb.status == RS::Waybill::STATUS_DEACTIVATED)
          self.rs_id = nil
          self.rs_number = nil
          self.rs_status = RS::Waybill::STATUS_SAVED
          self.rs_start = nil
          self.rs_end = nil
        else
          self.rs_id = id
          self.rs_number = wb.number
          self.rs_status = wb.status
          self.rs_start = wb.activate_date
          self.rs_end = wb.delivery_date
        end
        self.save!
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
        when RS::Waybill::STATUS_DEACTIVATED
          'remove-sign'
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
        when RS::Waybill::STATUS_DEACTIVATED
          'გაუქმებული'
        else
          'გადაუგზავნელი'
        end
      end
    end
  end
end
