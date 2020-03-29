class CsvProcessor < ApplicationJob
    queue_as :default

    require 'csv'
    def perform(identifier)
        csv = CsvFile.find_by_identifier(identifier)
        Rails.logger.debug("*" * 30)
        Rails.logger.debug "IT'S DONE"
    end

    def csv_process
        # CSV.parse(csv.file.download, headers: true).with_index do |row, i|
        #     processing
        # end
    end

    def phone_format
        # phone.scan(/\d/).join if phone
    end
end