# -*- encoding : utf-8 -*-
module Sys
  class WarehouseController < SysController
    def index
      @title = 'საწყობები'
      @warehouses = Sys::Warehouse.all.asc(:name)
    end

    def new
      @title = 'ახალი საწყობი'
      if request.post?
        @warehouse = Sys::Warehouse.new(params[:sys_warehouse])
        if @warehouse.valid?
          if @warehouse.sap_warehouse
            @warehouse.save!
            redirect_to sys_warehouses_url, :notice => 'საწყობი შექმნილია'
          else
            @error = 'შესაბამისი საწყობი ვერ მოიძებნა SAP-ში.'
          end
        end
      else
        @warehouse = Sys::Warehouse.new
      end
    end

    def edit
      @title = 'საწყობის შეცვლა'
      @warehouse = Sys::Warehouse.find(params[:id])
      if request.put?
        redirect_to sys_show_warehouse_url(@warehouse) if @warehouse.update_attributes(params[:sys_warehouse])
      end
    end

    def show
      @warehouse = Sys::Warehouse.find(params[:id])
      @sap_warehouse = @warehouse.sap_warehouse
      @title = @warehouse.name
    end
  end
end
