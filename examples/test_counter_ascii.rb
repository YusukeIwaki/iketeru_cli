#!/usr/bin/env ruby

require 'bundler/setup'
require 'iketeru_cli'

# Test with ASCII border style
class Counter < IketeruCli::Component
  def initialize
    super
    @state = { count: 11 }
  end

  def render
    box(border: :ascii, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Press SPACE to increment, Q to quit", color: :gray)
    end
  end
end

counter = Counter.new
puts "Counter with ASCII border:"
puts counter.render