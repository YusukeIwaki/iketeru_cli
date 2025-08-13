#!/usr/bin/env ruby

require 'bundler/setup'
require 'rink'

# Simplest possible box test
class SimpleTest < Rink::Component
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
class PaddedTest < Rink::Component
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
class LongTest < Rink::Component
  def render
    box(border: :single, padding: 1) do
      text("This is a much longer text string")
    end
  end
end

puts "Long text test:"
puts LongTest.new.render