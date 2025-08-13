#!/usr/bin/env ruby

require 'bundler/setup'
require 'iketeru_cli'

# Test specifically with Counter: 11
class Counter < IketeruCli::Component
  def initialize
    super
    @state = { count: 11 }
  end

  def mount
    on_key(' ') { set_state(count: @state[:count] + 1) }
    on_key('q') { exit_app }
  end

  def render
    box(border: :single, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Press SPACE to increment, Q to quit", color: :gray)
    end
  end
end

counter = Counter.new
puts "Counter with value 11:"
puts counter.render
puts

# Show raw line data
rendered = counter.render.to_s
puts "Line-by-line analysis:"
rendered.split("\n").each_with_index do |line, i|
  stripped = line.gsub(/\e\[[^m]*m/, '')
  puts "Line #{i}: '#{stripped}' (length: #{stripped.length})"
end