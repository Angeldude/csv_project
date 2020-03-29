class CsvProcessingController < ApplicationController
    def input
        @csv_file = CsvFile.new
    end

    def output
        @csvs = ProcessedCsv.find_by_identifier(params[:identifier])
    end

    def create_or_update
        @csv_file = CsvFile.find_by_identifier(get_params[:identifier])
        respond_to do |format|
            if @csv_file.present?
                if get_params[:file].present?
                    @csv_file.file.detach
                    @csv_file.file.attach(get_params[:file])
                    # Poo.perform_async(get_params[:identifier])
                    format.html {redirect_to root_path, notice: "#{get_params[:identifier]} updated!"}
                else
                    @csv_file.file = nil
                    @csv_file.save
                    format.html { render :input }
                end
            else
                @csv_file = CsvFile.new(get_params)
                if @csv_file.save
                    format.html { redirect_to root_path, notice: "We did it!"}
                else
                    format.html { render :input }
                end
            end
        end
    end

    private
    def get_params
        params.require(:csv_file).permit(:file, :identifier)
    end
end