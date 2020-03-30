require 'rails_helper'

RSpec.describe ProcessedCsv do
    it 'should not save a last name without a first name' do
        processed_csv = ProcessedCsv.new(last: "Stevens")
        expect(processed_csv.save).to be_falsy
    end
    it 'should save a first name without a last name' do
        processed_csv = ProcessedCsv.new(first: "Steven", row_number: 0, identifier: 'testing')
        expect(processed_csv.save).to be_truthy
    end
    it 'should not allow names to contain numbers or symbols' do
        processed_csv = ProcessedCsv.new(first: "Stev3ens", last: "Tri23")
        expect(processed_csv.save).to be_falsy
    end
    it 'should not save an invalid phone number' do
        processed_csv = ProcessedCsv.new(phone: "sicue233-2")
        expect(processed_csv.save).to be_falsy
    end
    it 'should save exactly 10 digits on a phone, no more, no less' do
        processed_csv = ProcessedCsv.new(phone: "233-(23).233")
        expect(processed_csv.save).to be_falsy
    end
    it 'should properly format a phone number' do
        processed_csv = ProcessedCsv.create!(phone: "2332331014", row_number:0, identifier:'testing')
        expect(processed_csv.phone_number).to eq('(233)233-1014')
    end
    it 'should not save an invalid email address' do
        processed_csv = ProcessedCsv.new(email: "s@icu@e23.com")
        expect(processed_csv.save).to be_falsy
    end
    it 'should not save a record without a row_number' do
        processed_csv = ProcessedCsv.new()
        expect(processed_csv.save).to be_falsy
    end
    it 'should not save a record without an identifier' do
        processed_csv = ProcessedCsv.new(row_number: 1)
        expect(processed_csv.save).to be_falsy
    end
    it 'should not allow bypassing validation to set identifier to null' do
        processed_csv = ProcessedCsv.create(row_number: 1, identifier: 'testing')
        expect{processed_csv.update_attribute(:identifier, nil)}.to raise_error(ActiveRecord::NotNullViolation)
    end
    it 'should not allow bypassing validation to set row_number to null' do
        processed_csv = ProcessedCsv.create(row_number: 1, identifier: 'testing')
        expect{processed_csv.update_attribute(:row_number, nil)}.to raise_error(ActiveRecord::NotNullViolation)
    end
    it 'should have a unique row_number and identifier' do
        processed_csv = ProcessedCsv.create(row_number: 1, identifier: 'testing')
        new_processed_csv = ProcessedCsv.new(row_number: 1, identifier: 'testing')
        expect(new_processed_csv.save).to be_falsy
    end
    it 'should not bypass validation to create a new processed_csv with duplicate row_number and identifier' do
        processed_csv = ProcessedCsv.create(row_number: 1, identifier: 'testing')
        new_processed_csv = ProcessedCsv.new(row_number: 2, identifier: 'testing')
        expect{new_processed_csv.update_attribute(:row_number, 1)}.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'should save with minimal information' do
        processed_csv = ProcessedCsv.new(row_number: 0, identifier: 'testing')
        expect(processed_csv.save).to be_truthy
    end
    it 'should save with all information' do
        processed_csv = ProcessedCsv.new(row_number: 0, identifier: 'testing', first: "Jane", last: "Doe", email: "jane@example.com", phone: '1234567890')
        expect(processed_csv.save).to be_truthy
    end

end