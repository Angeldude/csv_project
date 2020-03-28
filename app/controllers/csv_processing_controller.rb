class CsvProcessingController < ApplicationController
    def index
    end

    def import
        ProcessedCsv.import(get_params)
        redirect_to root_path, notification: "done!"
    end

    private

    def get_params
        params.permit(:file, :identifier)
    end
end