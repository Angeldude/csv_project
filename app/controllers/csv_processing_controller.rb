class CsvProcessingController < ApplicationController
    def index
        @csv_file = CsvFile.new
    end

    def create
        @csv_file = CsvFile.new(get_params)
        redirect_to root_path
    end

    private

    def get_params
        params.require(:csv_file).permit(:file, :identifier)
    end
end