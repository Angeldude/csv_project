class CsvProcessor < ApplicationJob
    queue_as :default

    require 'csv'
    def perform(identifier)
        csv = CsvFile.where(identifier: identifier)
        csv_process(csv.first, identifier)
    end

    private 
    def csv_process(csv, identifier)
        CSV.parse(csv.file.download, headers: true).each_with_index do |row, i|
            row_hash = csv_hash(row)
            temp = ProcessedCsv.find_by_row_number(i)
            if temp.present?
                temp.update_columns(row_hash)
            else
                hashed = row_hash
                row_hash[:identifier] = identifier
                row_hash[:row_number] = i
                temp = ProcessedCsv.new(hashed)
            end
            begin
                temp.save!
                err = CsvError.where(identifier: identifier, row_number: i)
                err.first.delete if err.present?
            rescue ActiveRecord::RecordInvalid => e
                if err.present?
                    err.first.update_attribute(:row_errors, temp.errors.full_messages)
                else
                    CsvError.create(identifier: identifier, row_number: i, row_errors: temp.errors.full_messages)
                end
                Rails.logger.debug(e.message)
            end
        end
    end

    def phone_format(phone)
        begin
            phone.scan(/\d/).join
        rescue NoMethodError
            ''
        end
    end

    def csv_hash(row)
        {
            phone: phone_format(row["phone"]),
            email: row["email"],
            first: row["first"],
            last: row["last"]
        }
    end
end