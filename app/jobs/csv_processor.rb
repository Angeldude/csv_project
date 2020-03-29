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
            hashed = row_hash
            temp = ProcessedCsv.new(hashed)
            err = CsvError.where(identifier: identifier, row_number: i)
            begin
                temp.save!
                CsvError.delete(err)
            rescue ActiveRecord::RecordInvalid
                CsvError.delete(err)
                CsvError.create(identifier: identifier, row_number: i, row_errors: temp.errors.full_messages)
            end
        end
    end

    def phone_format(phone)
        begin
            temp = phone.scan(/\d/).join
            temp.blank? ? phone : temp
        rescue NoMethodError
            phone
        end
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