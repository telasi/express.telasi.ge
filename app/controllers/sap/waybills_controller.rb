# -*- encoding : utf-8 -*-
module Sap
  class WaybillsController < SapController
    def index
      @title = 'ზედნადებები'
      @date = current_date
      @docs = Sap::Ext::MaterialDocument.by_user(current_user).where(:date => @date).asc(:mblnr)
    end

    def monitor
      @title = 'ზედნადებების მონიტორინგი'
      @start_date = start_date
      @end_date   = end_date
      @start_status  = get_status('start')
      @active_status = get_status('active')
      @closed_status = get_status('closed')
      stats = []
      stats << RS::Waybill::STATUS_SAVED  if @start_status
      stats << RS::Waybill::STATUS_ACTIVE if @active_status
      stats << RS::Waybill::STATUS_CLOSED if @closed_status
      @q = current_query
      warehouses = Sys::Warehouse.by_query(@q).map{|w| w.id } if @q
      @docs = Sap::Ext::MaterialDocument.by_user(current_user).by_date_interval(@start_date, @end_date).by_status(stats).by_warehouses(warehouses).asc(:mblnr)
      if request.xhr?
        render :partial => 'sap/waybills/list'
      end
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
            #elsif sap_doc.return?
            #  doc.type = Sap::Ext::MaterialDocument::TYPE_RETURN
          elsif sap_doc.sale?
            doc.type = Sap::Ext::MaterialDocument::TYPE_SALE
          end
          # storno
          doc.storno = sap_doc.storno?
          # warehouse
          item = sap_doc.items.first
          warehouse = Sys::Warehouse.where(:werks => item.werks, :lgort => item.lgort).first
          doc.warehouse = warehouse
          doc.users = warehouse.users
          # save document
          doc.save!
        elsif doc
          doc.destroy
        end
        # სტორნოზე შემოწმება
        if doc and doc.storno and (doc.rs_id.nil? or doc.rs_canceled?)
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
      @waybill.validate(:remote => Express::REMOTE_CHECK)
    end

    def send_to_rs
      doc = Sap::Ext::MaterialDocument.find(params[:id])
      sap_doc = doc.sap_doc
      waybill = sap_doc.to_waybill
      begin
        waybill.status = RS::Waybill::STATUS_SAVED
        RS.save_waybill(waybill, 'su' => Express::SU, 'sp' => Express::SP)
        if waybill.error_code == 0
          RS.activate_waybill('waybill_id' => waybill.id, 'su' => Express::SU, 'sp' => Express::SP)
          doc.sync_waybill!(waybill.id)
          msg = 'ზედნადები გაგზავნილია და აქტივირებულია.'
        else
          msg = "ზედნადების შენახვის შეცდომა: #{waybill.error_code}"
        end
      rescue Exception => ex
        msg = "ზედნადების შენახვის შეცდომა: #{ex.to_s}"
      end
      redirect_to sap_show_waybill_url(doc), :notice => msg
    end

    def sync_rs
      doc = Sap::Ext::MaterialDocument.find(params[:id])
      doc.sync_waybill!
      redirect_to sap_show_waybill_url(doc), :notice => 'სინქრონიზაცია დასრულეუბლია.'
    end

    def close_rs
      doc = Sap::Ext::MaterialDocument.find(params[:id])
      RS.close_waybill('waybill_id' => doc.rs_id, 'su' => Express::SU, 'sp' => Express::SP)
      doc.sync_waybill!
      redirect_to sap_show_waybill_url(doc), :notice => 'ზედნადები დახურულია.'
    end

    def cancel_rs
      doc = Sap::Ext::MaterialDocument.find(params[:id])
      RS.deactivate_waybill('waybill_id' => doc.rs_id, 'su' => Express::SU, 'sp' => Express::SP)
      doc.sync_waybill!
      redirect_to sap_show_waybill_url(doc), :notice => 'ზედნადები გაუქმებულია.'
    end

    def no_role?
      true
    end

    private

    def current_query
      current_param('waybill', 'q')
    end

    def current_date
      Date.strptime(current_param('waybill', 'date', Date.today.strftime(DATE_FORMAT)), DATE_FORMAT)
    end

    def start_date
      Date.strptime(current_param('waybill', 'start_date', (Date.today << 1).strftime(DATE_FORMAT)), DATE_FORMAT)
    end

    def end_date
      Date.strptime(current_param('waybill', 'end_date', Date.today.strftime(DATE_FORMAT)), DATE_FORMAT)
    end

    def get_status(status)
      current_param('waybill', "#{status}_status", 'true') == 'true'
    end
  end
end
