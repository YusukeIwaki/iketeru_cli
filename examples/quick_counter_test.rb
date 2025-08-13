#!/usr/bin/env ruby

require 'bundler/setup'
require 'iketeru_cli'

class QuickCounter < IketeruCli::Component
  def initialize
    super
    @state = { count: 0 }
    @test_mode = true
  end

  def mount
    on_key(' ') { set_state(count: @state[:count] + 1) }
    on_key('q') { exit_app }
    
    # Auto-exit after a short time for testing
    Thread.new do
      sleep 0.5
      exit_app if @test_mode
    end
  end

  def render
    box(border: :single, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Press SPACE to increment, Q to quit", color: :gray)
      text("(Auto-exiting for test)", color: :yellow)
    end
  end
end

puts "Starting quick counter test..."
IketeruCli.render(QuickCounter.new)
puts "Counter test completed."