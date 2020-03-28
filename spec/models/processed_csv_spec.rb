require 'rails_helper'

RSpec.describe ProcessedCsv do
    it 'should have some data' do
        csv = ProcessedCsv.new
        expect(csv.save!).to raise_exception
    end
end