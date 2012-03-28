# -*- encoding : utf-8 -*-
module Sap
  class WaybillsController < ApplicationController
    def index
      @title = 'ზედნადებები'
      @date = current_date
      @docs = Sap::Ext::MaterialDocument.where(:date => @date)
    end

    def sync
      date = current_date
      sap_docs = Sap::MaterialDocument.where(:mandt => Express::Sap::MANDT, :budat => date.strftime('%Y%m%d'))
      sap_docs.each do |sap_doc|
        doc = Sap::Ext::MaterialDocument.where(:mblnr => sap_doc.mblnr, :mjahr => sap_doc.mjahr).first
        if sap_doc.waybill_document?
          doc = Sap::Ext::MaterialDocument.new(:mblnr => sap_doc.mblnr, :mjahr => sap_doc.mjahr) unless doc
          doc.date = sap_doc.budat_date
          # type
          if sap_doc.purchase?
            doc.type = Sap::Ext::MaterialDocument::TYPE_PURCHASE
          elsif sap_doc.inner?
            doc.type = Sap::Ext::MaterialDocument::TYPE_INNER
          elsif sap_doc.return?
            doc.type = Sap::Ext::MaterialDocument::TYPE_RETURN
          elsif sap_doc.sale?
            doc.type = Sap::Ext::MaterialDocument::TYPE_SALE
          end
          # warehouse
          item = sap_doc.items.first
          warehouse = Sys::Warehouse.where(:werks => item.werks, :lgort => item.lgort).first
          doc.warehouse = warehouse
          # save document
          doc.save!
        elsif doc
          doc.destroy
        end
      end
      redirect_to sap_waybills_url, :notice => 'სინქრონიზაცია დასრულებულია.'
    end

    def show
      @title = 'ზედნადების ნახვა'
      @doc = Sap::Ext::MaterialDocument.find(params[:id])
      @sap_doc = @doc.sap_doc
      @waybill = @sap_doc.to_waybill 
    end

    private

    def current_date
      unless @__date_initialized
        if params[:date]
          @__date = Date.strptime(params[:date], '%d-%b-%Y')
          Sys::Preference.set(current_user, 'waybill_date', params[:date])
        else
          txt = Sys::Preference.get(current_user, 'waybill_date')
          if txt and not txt.strip.empty?
            @__date = Date.strptime(txt, '%d-%b-%Y')
          else
            @__date = Date.today
          end
        end
        @__date_initialized = true
      end
      @__date
    end
  end
end
