require 'spec_helper'
require 'stringio'

RSpec.describe IketeruCli::Renderer do
  before(:all) do
    skip 'IketeruCli::Renderer not defined' unless defined?(IketeruCli::Renderer)
  end
  # Minimal component for rendering test
  class CountingComponent < IketeruCli::Component
    def initialize(val = 0)
      super()
      @state = { n: val }
    end

    def render
      box(border: :single) do
        text("Counter: #{@state[:n]}")
      end
    end
  end

  def capture_stdout
    old = $stdout
    sio = StringIO.new
    $stdout = sio
    yield
    sio.string
  ensure
    $stdout = old
  end

  it 'moves cursor up by (previous_height - 1) to avoid upward drift' do
    component = CountingComponent.new(0)
    renderer = IketeruCli::Renderer.new(component)
    renderer.instance_variable_set(:@running, true)
    component.instance_variable_set(:@mounted, true)

    first_output = capture_stdout { renderer.rerender }

    expected_height = component.render.render.split("\n").size
    expect(expected_height).to be > 1

    component.set_state(n: 1)
    second_output = capture_stdout { renderer.rerender }

    match = second_output.match(/\e\[(\d+)A/)
    expect(match).not_to be_nil
    moved_lines = match[1].to_i
    expect(moved_lines).to eq(expected_height - 1), "Expected move #{expected_height - 1}, got #{moved_lines}. Output: #{second_output.inspect}"

    expect(second_output).not_to start_with("\n")
  end

  it 'persists final frame on cleanup when alt screen mode simulated' do
    component = CountingComponent.new(0)
    renderer = IketeruCli::Renderer.new(component)
    renderer.instance_variable_set(:@running, true)
    component.instance_variable_set(:@mounted, true)
    # First render
    out1 = capture_stdout { renderer.rerender }
    # Simulate alt screen being active
    renderer.instance_variable_set(:@use_alt_screen, true)
    combined = capture_stdout { renderer.send(:cleanup) }
    # Frame printed once during rerender and once during cleanup (persistence)
    total = (out1 + combined).scan('┌').size
    expect(total).to eq(2), "Expected frame to be printed twice (once normal, once persist), got #{total}."
    expect(combined).to include('Counter: 0')
  end

  it 'prints only one frame and a CRLF on cleanup in non-alt mode' do
    component = CountingComponent.new(0)
    renderer = IketeruCli::Renderer.new(component)
    renderer.instance_variable_set(:@running, true)
    component.instance_variable_set(:@mounted, true)
    combined = capture_stdout { renderer.rerender; renderer.send(:cleanup) }
    # Only one frame top border
  expect(combined.scan('┌').size).to eq(1)
  # Ensure CRLF appears before (optional) cursor show sequence
  expect(combined).to match(/\r\n(?:\e\[\?25h)?\z/)
  end
end
