# -*- encoding : utf-8 -*-
module Sys
  class WarehouseController < SysController
    def index
      @title = 'საწყობები'
      @warehouses = Sys::Warehouse.asc(:werks, :lgort).paginate(:page => params[:page], :per_page => 10)
    end

    def new
      @title = 'ახალი საწყობი'
      if request.post?
        @warehouse = Sys::Warehouse.new(params[:sys_warehouse])
        if @warehouse.valid?
          existing = Sys::Warehouse.where(:werks => @warehouse.werks, :lgort => @warehouse.lgort).first
          if existing
            @error = 'ეს საწყობი უკვე სიაშია.'
          elsif @warehouse.sap_warehouse
            @warehouse.name = @warehouse.sap_warehouse.lgobe
            @warehouse.save!
            redirect_to sys_warehouses_url, :notice => 'საწყობი შექმნილია.'
          else
            @error = 'შესაბამისი საწყობი ვერ მოიძებნა SAP-ში.'
          end
        end
      else
        @warehouse = Sys::Warehouse.new
      end
    end

    def sync
      warehouses = Sap::Warehouse.all(:conditions => ['MANDT=?', Express::Sap::MANDT])
      warehouses.each do |w|
        warehouse = Sys::Warehouse.where(:werks => w.werks, :lgort => w.lgort).first
        warehouse = Sys::Warehouse.new(:werks => w.werks, :lgort => w.lgort) unless warehouse
        warehouse.name = w.lgobe
        warehouse.save!
      end
      redirect_to sys_warehouses_url
    end

#    def edit
#      @title = 'საწყობის შეცვლა'
#      @warehouse = Sys::Warehouse.find(params[:id])
#      if request.put?
#        redirect_to sys_show_warehouse_url(@warehouse), :notice => 'საწყობი შეცვლილია.' if @warehouse.update_attributes(params[:sys_warehouse])
#      end
#    end

    def show
      @warehouse = Sys::Warehouse.find(params[:id])
      @sap_warehouse = @warehouse.sap_warehouse
      @sap_addresses = @sap_warehouse.addresses
      @title = @warehouse.name
      @users = Sys::User.asc(:first_name, :last_name)
    end

#    def delete
#      @warehouse = Sys::Warehouse.find(params[:id])
#      @warehouse.destroy
#      redirect_to sys_warehouses_url, :notice => 'საწყობი წაშლილია.'
#    end
  end
end
