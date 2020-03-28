class CsvProcessingController < ApplicationController
    def index
    end

    def import
        ProcessedCsv.import(params[:file])
        redirect_to root_path
    end
end