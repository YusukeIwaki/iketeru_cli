#!/usr/bin/env ruby

require 'bundler/setup'
require 'rink'

# Test the Counter component without starting the interactive app
class Counter < Rink::Component
  def initialize
    super
    @state = { count: 0 }
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

# Create and test the component
counter = Counter.new
# Call mount to register key handlers
counter.mount
# Set mounted flag without triggering rerender
counter.instance_variable_set(:@mounted, false)

# Test initial render
puts "Initial render:"
puts counter.render
puts

# Simulate incrementing counter
counter.handle_key(' ')
puts "After pressing SPACE:"
puts counter.render
puts

# Test multiple increments
3.times { counter.handle_key(' ') }
puts "After pressing SPACE 3 more times:"
puts counter.render

puts "\nComponent test completed successfully!"