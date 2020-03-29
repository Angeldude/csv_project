class CsvProcessingController < ApplicationController
    before_action :set_csv_file, only: [:create]
    def input
        @csv_file = CsvFile.new
    end

    def output
        @csvs = ProcessedCsv.find_by_identifier(params[:identifier])
    end

    def create
        @csv_file ||= CsvFile.new(get_params)
        respond_to do |format|
            if @csv_file.save && get_params[:file].present?
                format.html { redirect_to root_path, notice: "We did it!"}
            elsif @csv_file.present?
                @csv_file.file.detach
                @csv_file.file.attach(get_params[:file])
                # Poo.perform_async(get_params[:identifier])
                format.html {redirect_to root_path, notice: "#{get_params[:identifier]} updated"}
            else
                format.html { render :input }
            end
        end
    end

    private
    def set_csv_file
        @csv_file = CsvFile.find_by_identifier(get_params[:identifier])
    end
    def get_params
        params.require(:csv_file).permit(:file, :identifier)
    end
end