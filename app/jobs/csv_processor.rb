class CsvProcessor #< ApplicationJob
    # queue_as :low_priority

    require 'csv'
    def perform(identifier)
        csv = CsvFile.where(identifier: identifier)
        csv_process(csv.first, identifier)
    end

    private 
    def csv_process(csv, identifier)
        rows = ProcessedCsv.where(identifier: identifier)
        csv_file = csv.file.download
        CSV.parse(csv_file, headers: true).each_with_index do |row, i|
            row_hash = csv_hash(row)
            temp = ProcessedCsv.find_by_row_number(i)
            if temp.present?
                if (csv_file.split.size - 1) != (rows.size)
                    ProcessedCsv.delete(rows)
                    hashed = row_hash
                    row_hash[:identifier] = identifier
                    row_hash[:row_number] = i
                    temp = ProcessedCsv.new(row_hash)
                else
                    temp.update_columns(row_hash)
                end
            else
                hashed = row_hash
                row_hash[:identifier] = identifier
                row_hash[:row_number] = i
                temp = ProcessedCsv.new(hashed)
            end
            begin
                temp.save!
                err = CsvError.where(identifier: identifier, row_number: i)
                err.first.destroy if err.present?
            rescue ActiveRecord::RecordInvalid => e
                err = CsvError.where(identifier: identifier, row_number: i)
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