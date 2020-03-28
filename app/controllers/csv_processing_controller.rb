class CsvProcessingController < ApplicationController
    def index
        @csv_file = CsvFile.new
    end

    def create
        @csv_file = CsvFile.find_or_create_by(identifier: get_params[:identifier])
        respond_to do |format|
            if @csv_file.present?
                @csv_file.file.detach
                @csv_file.file.attach(get_params[:file])
                format.html {redirect_to root_path, notice: "#{get_params[:identifier]} updated"}
            elsif @csv_file.save
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