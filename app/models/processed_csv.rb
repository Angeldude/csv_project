class ProcessedCsv < ApplicationRecord
    validates :first, length: {minimum: 2}, allow_nil: true, format: {with: /\A[a-zA-z]*\z/, message: 'can only contain letters'}
    validates :first, presence: { message: "can't be blank if Last name is filled"}, if: Proc.new{|row| row.last.present?}
    validates :last, length: {minimum: 2}, allow_nil: true, format: {with: /\A[a-zA-z]*\z/, message: 'can only contain letters'}

    validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, message: 'must be standard and valid'}, allow_nil: true
    validates :phone, format: {with: /\A[\d\.\-\)\(]*\z/ , message: 'must contain only these characters: 0-9, - ( ) .'}
    validate :phone_validate

    def phone_number
        phone.clone.insert(0,'(').insert(4,')').insert(8,'-')
    end

    private 
    def phone_validate
        testing = phone.scan(/[\d]/).join
        if testing.size == 10
            if testing[0].eql?('0') || testing[3].eql?('1')
                errors.add(:phone, 'must not start with 0 (area code) or 1 (prefix) ')
            end
        else
            errors.add(:phone, 'must be 10 digits')
        end
    end
end