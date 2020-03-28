require 'rails_helper'

RSpec.describe ProcessedCSV do
    it 'should have some data' do
        csv = ProcessedCSV.new
        expect(csv).to be_truthy
    end
end