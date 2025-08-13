#!/usr/bin/env ruby

require 'bundler/setup'
require 'rink'

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

Rink.render(Counter.new)