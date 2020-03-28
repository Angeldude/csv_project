require 'rails_helper'

RSpec.describe ProcessedCsv do
    it 'should fail to save with no data' do
        csv = ProcessedCsv.new
        expect(csv.save!).to raise_exception
    end
end