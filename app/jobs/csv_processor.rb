class CsvProcessor < ApplicationJob
    queue_as :low_priority

    require 'csv'
    def perform(identifier)
        csv = CsvFile.where(identifier: identifier)
        csv_process(csv.first, identifier)
    end

    private 
    def csv_process(csv, identifier)
        rows = ProcessedCsv.where(identifier: identifier)
        ProcessedCsv.delete(rows)
        CSV.parse(csv.file.download, headers: true).each_with_index do |row, i|
            row_hash = csv_hash(row, identifier, i)
            temp = ProcessedCsv.new(row_hash)
            err = CsvError.where(identifier: identifier, row_number: i)
            CsvError.delete(err)
            CsvError.create(identifier: identifier, row_number: i, row_errors: temp.errors.full_messages) unless temp.save
        end
    end

    def phone_format(phone)
        phone.present? ? phone.scan(/\d/).join : phone     
    end

    def csv_hash(row, identifier, row_count)
        {
            phone: phone_format(row["phone"]),
            email: row["email"],
            first: row["first"],
            last: row["last"],
            identifier: identifier,
            row_number: row_count
        }
    end
end