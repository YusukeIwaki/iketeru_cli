#!/usr/bin/env ruby

require 'bundler/setup'
require 'rink'

# Debug version to inspect rendering
class Counter < Rink::Component
  def initialize
    super
    @state = { count: 11 }  # Use 11 to match your example
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
result = counter.render

puts "Raw output with escape sequences visible:"
puts result.inspect
puts "\n---\n"

puts "Rendered output:"
puts result
puts "\n---\n"

# Show each line length
rendered = result.to_s
rendered.split("\n").each_with_index do |line, i|
  visible_length = line.gsub(/\e\[[^m]*m/, '').length
  raw_length = line.length
  puts "Line #{i}: visible=#{visible_length}, raw=#{raw_length}"
  puts "  Raw: #{line.inspect}"
  puts "  Visible: #{line.gsub(/\e\[[^m]*m/, '').inspect}"
end