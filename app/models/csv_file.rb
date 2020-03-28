class CsvFile < ApplicationRecord
    has_one_attached :file
    validates :identifier, presence: true, length: { minimum: 2}
end