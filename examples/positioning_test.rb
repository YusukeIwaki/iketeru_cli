#!/usr/bin/env ruby

require 'bundler/setup'
require 'rink'

puts "This is a line before the counter"
puts "This is another line before the counter"
puts "Starting counter below this line:"

class Counter < Rink::Component
  def initialize
    super
    @state = { count: 0 }
  end

  def mount
    on_key(' ') { set_state(count: @state[:count] + 1) }
    on_key('q') { exit_app }
    
    # Auto-exit after a short time for demo
    Thread.new do
      sleep 2
      exit_app
    end
  end

  def render
    box(border: :single, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Press SPACE to increment, Q to quit", color: :gray)
      text("(Auto-exiting in 2 seconds)", color: :yellow)
    end
  end
end

Rink.render(Counter.new)
puts "Counter has finished, this line appears after"