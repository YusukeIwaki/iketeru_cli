#!/usr/bin/env ruby

require 'bundler/setup'
require 'iketeru_cli'

# Simplest possible box test
class SimpleTest < IketeruCli::Component
  def render
    box(border: :single) do
      text("Test")
    end
  end
end

puts "Simple box test:"
puts SimpleTest.new.render
puts

# Test with padding
class PaddedTest < IketeruCli::Component
  def render
    box(border: :single, padding: 1) do
      text("Test")
    end
  end
end

puts "Padded box test:"
puts PaddedTest.new.render
puts

# Test with longer text
class LongTest < IketeruCli::Component
  def render
    box(border: :single, padding: 1) do
      text("This is a much longer text string")
    end
  end
end

puts "Long text test:"
puts LongTest.new.render