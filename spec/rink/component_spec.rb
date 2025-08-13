require 'spec_helper'

RSpec.describe Rink::Component do
  describe '#initialize' do
    it 'initializes with empty state' do
      component = Rink::Component.new
      expect(component.state).to eq({})
    end

    it 'accepts props' do
      component = Rink::Component.new(title: 'Test')
      expect(component.props).to eq(title: 'Test')
    end
  end

  describe '#set_state' do
    it 'updates the state' do
      component = Rink::Component.new
      component.set_state(count: 1)
      expect(component.state[:count]).to eq(1)
    end

    it 'merges state updates' do
      component = Rink::Component.new
      component.set_state(count: 1)
      component.set_state(name: 'Test')
      expect(component.state).to eq(count: 1, name: 'Test')
    end
  end

  describe '#on_key' do
    it 'registers key handlers' do
      component = Rink::Component.new
      handler_called = false
      
      component.on_key('a') { handler_called = true }
      component.handle_key('a')
      
      expect(handler_called).to be true
    end

    it 'does not call handler for unregistered keys' do
      component = Rink::Component.new
      handler_called = false
      
      component.on_key('a') { handler_called = true }
      component.handle_key('b')
      
      expect(handler_called).to be false
    end
  end

  describe '#render' do
    it 'raises NotImplementedError if not overridden' do
      component = Rink::Component.new
      expect { component.render }.to raise_error(NotImplementedError)
    end
  end

  describe 'DSL methods' do
    class TestComponent < Rink::Component
      def render
        box(border: :single) do
          text("Hello", color: :green)
        end
      end
    end

    it 'provides box helper method' do
      component = TestComponent.new
      result = component.render
      expect(result).to be_a(Rink::Box)
    end

    it 'provides text helper method' do
      component = TestComponent.new
      text = component.text("Hello", color: :green)
      expect(text).to be_a(Rink::Text)
      expect(text.content).to eq("Hello")
    end
  end
end