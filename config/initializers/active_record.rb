# -*- encoding : utf-8 -*-
module ActiveRecord
  class Base
    # ამ მეთოდის მეშვეობით ხდება თარიღის ველის განსაზღვრა SAP-ის ცხრილებისთვის.
    def self.date_fields(*fields)
      fields.each do |field|
        define_method("#{field}_date") do
          date = send field.to_s
          Date.strptime(date, '%Y%m%d') if date
        end
        define_method("#{field}_date=") do |value|
          send( "#{field}=", value.strftime('%Y%m%d') ) if value
        end
      end
    end
  end
end
