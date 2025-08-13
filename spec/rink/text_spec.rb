require 'spec_helper'

RSpec.describe Rink::Text do
  describe '#initialize' do
    it 'stores content and options' do
      text = Rink::Text.new("Hello", color: :green)
      expect(text.content).to eq("Hello")
      expect(text.options[:color]).to eq(:green)
    end
  end

  describe '#render' do
    it 'renders plain text without options' do
      text = Rink::Text.new("Hello")
      expect(text.render).to eq("Hello")
    end

    it 'renders text with color' do
      text = Rink::Text.new("Hello", color: :green)
      expect(text.render).to eq("\e[32mHello\e[0m")
    end

    it 'renders text with bold' do
      text = Rink::Text.new("Hello", bold: true)
      expect(text.render).to eq("\e[1mHello\e[0m")
    end

    it 'renders text with underline' do
      text = Rink::Text.new("Hello", underline: true)
      expect(text.render).to eq("\e[4mHello\e[0m")
    end

    it 'renders text with multiple styles' do
      text = Rink::Text.new("Hello", color: :green, bold: true, underline: true)
      expect(text.render).to eq("\e[32;1;4mHello\e[0m")
    end

    it 'renders text with background color' do
      text = Rink::Text.new("Hello", background: :blue)
      expect(text.render).to eq("\e[44mHello\e[0m")
    end

    it 'supports gray color alias' do
      text = Rink::Text.new("Hello", color: :gray)
      expect(text.render).to eq("\e[90mHello\e[0m")
    end
  end

  describe '#to_s' do
    it 'returns rendered text' do
      text = Rink::Text.new("Hello", color: :green)
      expect(text.to_s).to eq(text.render)
    end
  end
end