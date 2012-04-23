# -*- encoding : utf-8 -*-
module Sap
  class WaybillsController < SapController
    def index
      @title = 'ზედნადებები'
      @date = current_date
      @docs = Sap::Ext::MaterialDocument.by_user(current_user).where(:date => @date).asc(:mblnr)
    end

    def monitor
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
      @docs = Sap::Ext::MaterialDocument.by_user(current_user).by_date_interval(@start_date, @end_date).by_status(stats).by_q(@q).asc(:mblnr)
      respond_to do |format|
        format.html do
          @title = 'ზედნადებების მონიტორინგი'
          render :partial => 'sap/waybills/list' if request.xhr?
        end
        format.xls do
          to_xls(@docs, 'tmp/waybill.xls')
          send_file 'tmp/waybill.xls', :type => :xls, :disposition => 'inline'
        end
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
          doc.werks = item.werks
          doc.lgort = item.lgort
          doc.warehouse = warehouse
          doc.users = warehouse.users
          # cost center
          sap_warehouse = warehouse.sap_warehouse
          sap_addresses = sap_warehouse.addresses if sap_warehouse
          if sap_addresses and not sap_addresses.first.nil?
            address = sap_addresses.first
            doc.cost_center = address.address.floor
            doc.cost_center_name = address.address.cost_center.ltext
          end
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

    def to_xls(docs, file)
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet
      sheet1.name = 'waybills'
      sheet1[0, 0] = 'დოკ. ნომერი'
      sheet1[0, 1] = 'RS სტატუსი'
      sheet1[0, 2] = 'გამოწერის თარიღი'
      sheet1[0, 3] = 'საწყობი'
      sheet1[0, 4] = 'საწარმო'
      sheet1[0, 5] = 'საწყობის დასახელება'
      sheet1[0, 6] = 'ხარჯის ცენტრი'
      sheet1[0, 7] = 'ხარჯის ცენტრი, დასახელება'
      sheet1[0, 8] = 'ზედნადების ID'
      sheet1[0, 9] = 'ზედნადების ნომერი'
      sheet1[0, 10] = 'ზედნადების გაგზავნის თარიღი'
      sheet1[0, 11] = 'ზედნადების დასრულების თარიღი'
      row = 1
      docs.each do |doc|
        sheet1[row, 0] = doc.mblnr
        if (doc.rs_sent? or doc.rs_closed?) and doc.storno
          sheet1[row, 1] = 'სტორნირებული'
        elsif doc.rs_sent?
          sheet1[row, 1] = 'გაგზავნილი'
        elsif doc.rs_closed?
          sheet1[row, 1] = 'დასრულებული'
        elsif doc.rs_canceled?
          sheet1[row, 1] = 'გაუქმებული'
        else
          sheet1[row, 1] = 'გადაუგზავნელი'
        end
        sheet1[row, 2] = doc.date.strftime('%d-%b-%Y')
        sheet1[row, 3] = doc.warehouse.lgort
        sheet1[row, 4] = doc.warehouse.werks
        sheet1[row, 5] = doc.warehouse.name
        sheet1[row, 6] = doc.cost_center
        sheet1[row, 7] = doc.cost_center_name
        sheet1[row, 8] = doc.rs_id
        sheet1[row, 9] = doc.rs_number
        sheet1[row, 10] = doc.rs_start.strftime('%d-%b-%Y %H:%M') if doc.rs_start
        sheet1[row, 11] = doc.rs_end.strftime('%d-%b-%Y %H:%M')   if doc.rs_end
        row += 1
      end
      f1 = Spreadsheet::Format.new(:border => true, :weight => :bold, :size => 12)
      f2 = Spreadsheet::Format.new(:border => true)
      0.upto(docs.size) do |j|
        if j == 0
          0.upto(11) { |i| sheet1.row(j).set_format(i, f1) }
        else
          0.upto(11) { |i| sheet1.row(j).set_format(i, f2) }
        end
      end
      book.write file
    end
  end
end
