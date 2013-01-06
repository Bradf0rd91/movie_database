class Mov
  class << self
    def valid_year? year
      year =~ /[0-9][0-9][0-9][0-9]|Unknown/
    end

    def valid_type? type
      ["DVD", "DVD-Rom", "Blu-Ray", "Digital Media"].include?(type)
    end
  end
end