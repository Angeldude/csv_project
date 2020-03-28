class Poo
    include Sidekiq::Worker

    def perform(args)
        puts "*" * 30
        puts "IT'S DONE"
    end
end