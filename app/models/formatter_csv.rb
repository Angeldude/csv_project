module FormatterCsv
    def self.formatting(row)
        obj = FormatCsvObj.new(row["first"], row["last"], row["phone"], row["email"])
        obj.format
    end
    class FormatCsvObj
        attr_reader :first, :last, :phone, :email
        def initialize(first, last, phone, email)
            @first = first
            @last = last
            @phone = phone
            @email = email
        end

        def format
            {first: first, last: last, phone: phone_format, email: email}
        end

        private 

        def phone_format
            phone.scan(/\d/).join
        end
    end
end