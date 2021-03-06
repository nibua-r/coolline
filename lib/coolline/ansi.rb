# -*- coding: utf-8 -*-

class Coolline
  # Mixin that allows to manipulate strings that contain ANSI color codes:
  # getting their length, printing their n first characters, etc.
  #
  # Additionally, it can output certain commonly needed sequences — using the
  # {#print} method to write to the output.
  module ANSI
    Code = %r{(\e\[\??\d+(?:[;\d]*)\w)}

    # @return [Integer] Amount of characters within the string, disregarding
    #   color codes.
    def ansi_length(string)
      strip_ansi_codes(string).length
    end

    # @return [String] The initial string without ANSI codes.
    def strip_ansi_codes(string)
      string.gsub(Code, "")
    end

    # @return [Boolean] True if the beginning of the string is an ANSI code.
    def start_with_ansi_code?(string)
      (string =~ Code) == 0
    end

    # Prints a slice of a string containing ANSI color codes. This allows to
    # print a string of a fixed width, while still keeping the right colors,
    # etc.
    #
    # @param [String] string
    # @param [Integer] start
    # @param [Integer] stop Stop index, excluded from the range.
    def ansi_print(string, start, stop)
      i = 0
      string.split(Code).each do |str|
        if start_with_ansi_code? str
          print str
        else
          if i >= start
            print str[0..(stop - i - 1)]
          elsif i < start && i + str.size >= start
            print str[(start - i), stop - start - 1]
          end

          i += str.size
          break if i >= stop
        end
      end
    end

    # Clears the current line and resets the select graphics settings.
    def reset_line
      print "\r\e[0m\e[0K"
    end

    # Clears the screen and moves the cursor to the top-left corner.
    def clear_screen
      print "\e[2J"
      go_to(1, 1)
    end

    # Moves the cursor to (x, y), where x is the colmun and y the line
    # number. Both are 1-indexed. The origin is the top-left corner.
    #
    # @param [Integer] x
    # @param [Integer] y
    def go_to(x, y)
      print "\e[#{y};#{x}H"
    end

    # Moves the cursor to the given (1-indexed) column number.
    def go_to_col(x)
      print "\e[#{x}G"
    end

    # Resets the current ansi color codes.
    def reset_color
      print "\e[0m"
    end

    # Erases the current line.
    def erase_line
      print "\e[0K"
    end

    # Moves to the beginning of the next line.
    def go_to_next_line
      print "\e[E"
    end

    # Moves to the beginning of the previous line.
    def go_to_previous_line
      print "\e[F"
    end
  end
end
