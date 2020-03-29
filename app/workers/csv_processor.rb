class CsvProcessor
    include Sidekiq::Worker

    def perform(args)
        p "*" * 30
        p "IT'S DONE"
    end
end