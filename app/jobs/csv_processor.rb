class CsvProcessor < ApplicationJob
    queue_as :default

    require 'csv'
    def perform(identifier)
        csv = CsvFile.where(identifier: identifier)
    end

    
    private 
    def csv_process
        # CSV.parse(csv.file.download, headers: true).with_index do |row, i|
            row_hash = csv_hash(row)
            ProcessedCsv.create(row_hash)
        # end
    end
    def phone_format
        # phone.scan(/\d/).join if phone
    end

    def csv_hash(row)
    end
end