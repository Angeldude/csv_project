class CsvFile < ApplicationRecord
    has_one_attached :file
    validates :identifier, presence: true, length: {minimum: 2}, uniqueness: true
    validates :file, presence: true
    validate :correct_content_type

    private 
    def correct_content_type
        if file.attached? && !file.content_type.in?(%w(application/vnd.ms-excel))
            errors.add(:file, 'Must be a CSV file')
        end
    end
end