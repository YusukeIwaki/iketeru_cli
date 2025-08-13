#!/usr/bin/env ruby

require 'bundler/setup'
require 'iketeru_cli'

puts "Before counter:"

class Counter < IketeruCli::Component
  def initialize
    super
    @state = { count: 0 }
  end

  def mount
    on_key(' ') { set_state(count: @state[:count] + 1) }
    on_key('q') { exit_app }
    
    # Auto-increment and exit for demonstration
    Thread.new do
      sleep 0.5
      handle_key(' ')  # Increment to 1
      sleep 0.5
      handle_key(' ')  # Increment to 2
      sleep 0.5
      handle_key(' ')  # Increment to 3
      sleep 0.5
      exit_app
    end
  end

  def render
    box(border: :single, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Auto-incrementing...", color: :yellow)
    end
  end
end

IketeruCli.render(Counter.new)
puts "After counter."