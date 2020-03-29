class CsvProcessor
    include Sidekiq::Worker

    require 'csv'
    def perform(identifier)
        csv = CsvFile.find_by_identifier(identifier)
        Rails.logger.debug("*" * 30)
        Rails.logger.debug "IT'S DONE"
    end

    def csv_process
        # CSV.parse(csv.file.download, headers: true) do |row|
        #     processing
        # end
    end
end