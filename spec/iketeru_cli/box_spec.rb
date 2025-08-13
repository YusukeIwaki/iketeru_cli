require 'spec_helper'

RSpec.describe IketeruCli::Box do
  # Helper class to provide component context for tests
  class TestContext < IketeruCli::Component
    def render
      # Not used in these tests
    end
  end

  let(:context) { TestContext.new }

  describe '#render' do
    it 'renders empty box with border' do
      box = IketeruCli::Box.new(border: :single)
      # Empty box doesn't need context
      result = box.render
      expect(result).to include('┌')
      expect(result).to include('┐')
      expect(result).to include('└')
      expect(result).to include('┘')
    end

    it 'renders box with text content' do
      box = IketeruCli::Box.new(border: :single) do
        text("Hello")
      end
      box.build_children(context)
      result = box.render
      expect(result).to include('Hello')
      expect(result).to include('│')
    end

    it 'renders box with padding' do
      box = IketeruCli::Box.new(border: :single, padding: 1) do
        text("Hi")
      end
      box.build_children(context)
      result = box.render
      lines = result.split("\n")
  # lines[0] top border
  # lines[1] top padding
  expect(lines[1]).to match(/^│\s+│$/)
  # lines[2] content
  expect(lines[2]).to match(/^│\sHi\s+│$/)
  # lines[3] bottom padding
  expect(lines[3]).to match(/^│\s+│$/)
    end

    it 'renders box with double border' do
      box = IketeruCli::Box.new(border: :double)
      result = box.render
      expect(result).to include('╔')
      expect(result).to include('╗')
      expect(result).to include('╚')
      expect(result).to include('╝')
    end

    it 'renders box with round border' do
      box = IketeruCli::Box.new(border: :round)
      result = box.render
      expect(result).to include('╭')
      expect(result).to include('╮')
      expect(result).to include('╰')
      expect(result).to include('╯')
    end

    it 'renders nested boxes' do
      box = IketeruCli::Box.new(border: :single) do
        box(border: :single) do
          text("Nested")
        end
      end
      box.build_children(context)
      result = box.render
      expect(result).to include('Nested')
      expect(result.scan('┌').length).to eq(2)
    end

    it 'renders multiple text elements' do
      box = IketeruCli::Box.new(border: :single, padding: 1) do
        text("Line 1")
        text("Line 2")
      end
      box.build_children(context)
      result = box.render
      expect(result).to include('Line 1')
      expect(result).to include('Line 2')
    end

    it 'preserves ANSI codes in styled text' do
      box = IketeruCli::Box.new(border: :single) do
        text("Hello", color: :green)
      end
      box.build_children(context)
      result = box.render
      expect(result).to include("\e[32mHello\e[0m")
    end

    it 'handles full-width characters without breaking border alignment' do
      box = IketeruCli::Box.new(border: :single, padding: 1) do
        text("カタカナ") # 4 full-width chars (display width 8)
        text("ABCD")     # 4 ascii chars (display width 4)
      end
      box.build_children(context)
      result = box.render
      lines = result.split("\n")
      # Extract content lines (skip top & bottom border)
      content_lines = lines[1..-2]
      interior_widths = content_lines.map do |l|
        next if l.start_with?('┌','└','╔','╚') # safety
        if l.start_with?('│') && l.end_with?('│')
          interior = l[1..-2]
          # Visible width approximation: count wide CJK/emoji as 2
          interior.each_char.reduce(0) do |sum,ch|
            code = ch.ord
            wide = (
              (0x1100..0x115F).cover?(code) ||
              (0x2E80..0xA4CF).cover?(code) ||
              (0xAC00..0xD7A3).cover?(code) ||
              (0xF900..0xFAFF).cover?(code) ||
              (0xFE10..0xFE19).cover?(code) ||
              (0xFE30..0xFE6F).cover?(code) ||
              (0xFF00..0xFF60).cover?(code) ||
              (0xFFE0..0xFFE6).cover?(code) ||
              (0x1F300..0x1F64F).cover?(code) ||
              (0x1F900..0x1F9FF).cover?(code) ||
              (0x20000..0x3FFFD).cover?(code)
            )
            sum + (wide ? 2 : 1)
          end
        else
          nil
        end
      end.compact
      expect(interior_widths.uniq.size).to eq(1)
    end

    it 'handles emoji width (approximate double-width) for alignment' do
      box = IketeruCli::Box.new(border: :single, padding: 1) do
        text("😀😀") # 2 emoji (treated as width 4)
        text("1234")
      end
      box.build_children(context)
      result = box.render
      lines = result.split("\n")
      content_lines = lines[1..-2]
      interior_widths = content_lines.map do |l|
        if l.start_with?('│') && l.end_with?('│')
          interior = l[1..-2]
          interior.each_char.reduce(0) do |sum,ch|
            code = ch.ord
            wide = (0x1F300..0x1FAFF).cover?(code)
            sum + (wide ? 2 : 1)
          end
        else
          nil
        end
      end.compact
      expect(interior_widths.uniq.size).to eq(1)
    end
  end
end
