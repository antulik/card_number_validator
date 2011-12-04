require 'readline'

class CardValidator

  def console
    Readline.completion_append_character = ""

    while line = Readline.readline('> ', true)
      if (line != "")

        case line
          when "exit"
            break

          when "help", "h"
            display_help

          else
            result = validate_card line
            puts colorize result
        end
      end
    end

  end

  def colorize text
    text.gsub!("(valid)", "(\e[32mvalid\e[0m)")
    text.gsub!("(invalid)", "(\e[31minvalid\e[0m)")
    text
  end

  def validate_card number
    number = number.delete(' ') #remove spaces

    type = card_type(number)
    is_valid = (valid_card_number?(number) and valid_card_length?(type, number))
    unless type
      type = "Unknown"
      is_valid = false
    end

    valid_str = is_valid ? "valid" : "invalid"
    "#{type}: #{number} (#{valid_str})"
  end

  def valid_card_number? number
    return false if number.to_s =~ /\D/ or number.to_s.empty? # number contains non-digits
    numbers_array = number.scan /\d/ #convert to array
    numbers_array = numbers_array.each_with_index.map { |num, index| (index % 2 == 1 ? 1 : 2) * num.to_i }
    sum = numbers_array.reduce(0) { |sum, x| sum + (x >= 10 ? (x % 10) + 1 : x) }
    sum % 10 == 0
  end

  def card_type number
    case number
      when /^34/, /^37/
        "AMEX"
      when /^4/
        "VISA"
      when /^5[1-5]/
        "MasterCard"
      when /^6011/
        "Discover"
      else
        nil
    end
  end

  def valid_card_length? card_type, card_number
    length = card_number.to_s.length
    case card_type
      when "AMEX"
        length == 15
      when "VISA"
        length == 16 or length == 13
      when "MasterCard"
        length == 16
      when "Discover"
        length == 16
      else
        false
    end
  end

  def display_help
    help = %$Credit Card Number validator:
This program validates credit card numbers

<number>  - to validate credit card number
exit      - close application
help or h - show this help information
$
    puts help
  end


end