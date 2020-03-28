class CsvProcessingController < ApplicationController
    def index
        @csv_file = CsvFile.new
    end

    def create
        @csv_file = CsvFile.new(get_params)
        respond_to do |format|
            if @csv_file.save
                format.html { redirect_to root_path, notice: "We did it!"}
            else
                format.html { render :index }
            end
        end
    end

    private

    def get_params
        params.require(:csv_file).permit(:file, :identifier)
    end
end