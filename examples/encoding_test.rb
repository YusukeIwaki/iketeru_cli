#!/usr/bin/env ruby

require 'bundler/setup'

# Test character widths
chars = {
  'ASCII': 'A',
  'Box Top-Left': '┌',
  'Box Horizontal': '─',
  'Box Vertical': '│',
  'Japanese': 'あ'
}

puts "Character width test:"
chars.each do |name, char|
  puts "#{name}: '#{char}'"
  puts "  Length: #{char.length}"
  puts "  Bytesize: #{char.bytesize}"
  puts "  Display width (estimate): #{char.chars.map { |c| c.bytesize == 1 ? 1 : 2 }.sum}"
end

puts "\nBox drawing test:"
puts "┌─────┐"
puts "│Hello│"
puts "└─────┘"

puts "\nLine length check:"
line = "│ Counter: 11                         │"
puts "Line: #{line}"
puts "Length: #{line.length}"
puts "Bytesize: #{line.bytesize}"

# Test Unicode display width
begin
  require 'unicode/display_width'
  puts "\nUsing unicode-display_width gem:"
  chars.each do |name, char|
    puts "#{name}: display_width = #{Unicode::DisplayWidth.of(char)}"
  end
rescue LoadError
  puts "\nunicode-display_width gem not installed"
end