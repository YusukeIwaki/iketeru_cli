require 'io/console'

module Rink
  module Terminal
    extend self

    def clear
      return unless STDOUT.tty?
      print "\e[2J\e[H"
    end

    def hide_cursor
      return unless STDOUT.tty?
      print "\e[?25l"
    end

    def show_cursor
      return unless STDOUT.tty?
      print "\e[?25h"
    end

    def move_cursor(x, y)
      return unless STDOUT.tty?
      print "\e[#{y};#{x}H"
    end

    def enter_alt_screen
      return unless STDOUT.tty?
      print "\e[?1049h"
    end

    def leave_alt_screen
      return unless STDOUT.tty?
      print "\e[?1049l"
    end

    def save_cursor
      return unless STDOUT.tty?
      print "\e[s"
    end

    def restore_cursor
      return unless STDOUT.tty?
      print "\e[u"
    end

    def enable_raw_mode
      return unless STDIN.tty?
      @original_stty = `stty -g`.chomp if RUBY_PLATFORM =~ /darwin|linux/
      STDIN.raw!
    rescue Errno::ENODEV, Errno::ENOTTY
      # Not a terminal, ignore
    end

    def disable_raw_mode
      return unless STDIN.tty?
      STDIN.cooked!
      system("stty #{@original_stty}") if @original_stty && RUBY_PLATFORM =~ /darwin|linux/
    rescue Errno::ENODEV, Errno::ENOTTY
      # Not a terminal, ignore
    end

    def read_key
      return :ctrl_c unless STDIN.tty?

      input = STDIN.getch

      if input == "\e"
        additional = STDIN.read_nonblock(2) rescue nil
        input += additional if additional
      end

      case input
      when "\e[A" then :up
      when "\e[B" then :down
      when "\e[C" then :right
      when "\e[D" then :left
      when "\r", "\n" then :enter
      when "\e" then :escape
      when "\t" then :tab
      when "\x7F", "\b" then :backspace
      when "\x03" then :ctrl_c
      when "\x04" then :ctrl_d
      else input
      end
    rescue Errno::ENODEV, Errno::ENOTTY
      :ctrl_c
    end

    def size
      rows, cols = STDIN.winsize
      { width: cols, height: rows }
    rescue
      { width: 80, height: 24 }
    end
  end
end
