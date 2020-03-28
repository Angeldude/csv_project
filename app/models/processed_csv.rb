class ProcessedCsv
    include FormatterCsv
    
    require 'csv'
    def self.import(args)
        if args[:file].present?
            CSV.foreach(args[:file], headers: true).with_index do |row, i|
                formatted = FormatterCsv.formatting(row)
                formatted[:row_number] = i
                formatted[:identifier] = args[:identifier]
                self.create(formatted)
            end
        else
            'missing file error message'
        end
    end

    def self.create(f)
        p f
    end

    def phone_number
        phone.clone.insert(0,'(').insert(4,')').insert(8,'-')
    end
end