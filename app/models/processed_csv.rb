class ProcessedCsv
    require 'csv'
    def self.import(file)
        CSV.foreach(file) do |row|
            p row
        end
    end
end