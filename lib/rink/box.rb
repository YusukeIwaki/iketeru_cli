module Rink
  class Box
    attr_reader :options, :children

    BORDERS = {
      single: {
        top_left: '┌',
        top_right: '┐',
        bottom_left: '└',
        bottom_right: '┘',
        horizontal: '─',
        vertical: '│'
      },
      double: {
        top_left: '╔',
        top_right: '╗',
        bottom_left: '╚',
        bottom_right: '╝',
        horizontal: '═',
        vertical: '║'
      },
      round: {
        top_left: '╭',
        top_right: '╮',
        bottom_left: '╰',
        bottom_right: '╯',
        horizontal: '─',
        vertical: '│'
      },
      ascii: {
        top_left: '+',
        top_right: '+',
        bottom_left: '+',
        bottom_right: '+',
        horizontal: '-',
        vertical: '|'
      }
    }.freeze

    def initialize(options = {}, &block)
      @options = options
      @children = []
      @content_lines = []
      @block = block
    end

    def build_children(component_context)
      if @block
        # Store original box to restore later
        original_current_box = component_context.instance_variable_get(:@current_box)
        component_context.instance_variable_set(:@current_box, self)

        # Execute block in component context
        component_context.instance_eval(&@block)

        # Restore original box
        component_context.instance_variable_set(:@current_box, original_current_box)
      end
    end

    def add_child(child)
      @children << child
    end

    def render
      # Ensure children are built if not already (only if there's a block)
      if @children.empty? && @block
        raise "Box must be built with component context before rendering. Use box.build_children(component_context)"
      end

      lines = collect_content_lines

      if options[:border]
        render_with_border(lines)
      else
        render_without_border(lines)
      end
    end

    def to_s
      render
    end

    private

    def collect_content_lines
      lines = []

      @children.each do |child|
        if child.respond_to?(:render)
          rendered = child.render
          if rendered.is_a?(String)
            rendered.split("\n").each { |line| lines << line }
          end
        end
      end

      lines
    end

    def render_with_border(lines)
      border_style = BORDERS[options[:border]] || BORDERS[:single]
      padding = options[:padding] || 0
      width = calculate_width(lines)
      result = []

      inner_width = width + padding * 2
      result << "#{border_style[:top_left]}#{border_style[:horizontal] * inner_width}#{border_style[:top_right]}"

      # Top padding lines
      padding.times do
        result << "#{border_style[:vertical]}#{' ' * inner_width}#{border_style[:vertical]}"
      end

      lines.each do |line|
        visible_len = display_width(strip_ansi(line))
        right_spaces = width - visible_len
        result << (
          "#{border_style[:vertical]}" +
          (' ' * padding) +
          line +
          (' ' * right_spaces) +
          (' ' * padding) +
          "#{border_style[:vertical]}"
        )
      end

      # Bottom padding lines
      padding.times do
        result << "#{border_style[:vertical]}#{' ' * inner_width}#{border_style[:vertical]}"
      end

      result << "#{border_style[:bottom_left]}#{border_style[:horizontal] * inner_width}#{border_style[:bottom_right]}"
      result.join("\n")
    end

    def render_without_border(lines)
      padding = options[:padding] || 0

      if padding > 0
        width = calculate_width(lines)
        padded_lines = apply_padding(lines, width, padding)
        padded_lines.join("\n")
      else
        lines.join("\n")
      end
    end

    def calculate_width(lines)
      lines.map { |line| display_width(strip_ansi(line)) }.max || 0
    end

    def display_width(str)
      # Calculate display width considering East Asian wide/fullwidth characters, emoji, etc.
      width = 0
      str.each_char do |ch|
        code = ch.ord
        case ch
        when "\t"
          # Advance to next tab stop (every 4 cols)
          advance = 4 - (width % 4)
          width += advance
        else
          # Control chars have zero width
          if code <= 0x1F || (code >= 0x7F && code <= 0x9F)
            next
          elsif east_asian_wide?(code)
            width += 2
          else
            width += 1
          end
        end
      end
      width
    end

    # Basic East Asian Width / emoji determination (approximation without extra gem)
    def east_asian_wide?(codepoint)
      (
        (0x1100..0x115F).cover?(codepoint) || # Hangul Jamo init. consonants
        (0x2329..0x232A).cover?(codepoint) ||
        (0x2E80..0xA4CF).cover?(codepoint) || # CJK ... Yi
        (0xAC00..0xD7A3).cover?(codepoint) || # Hangul Syllables
        (0xF900..0xFAFF).cover?(codepoint) || # CJK Compatibility Ideographs
        (0xFE10..0xFE19).cover?(codepoint) || # Vertical forms
        (0xFE30..0xFE6F).cover?(codepoint) || # CJK Compatibility Forms + small form variants
        (0xFF00..0xFF60).cover?(codepoint) || # Fullwidth Forms
        (0xFFE0..0xFFE6).cover?(codepoint) || # Fullwidth symbol variants
        (0x1F300..0x1F64F).cover?(codepoint) || # Misc Symbols and Pictographs + Emoticons
        (0x1F900..0x1F9FF).cover?(codepoint) || # Supplemental Symbols and Pictographs
        (0x20000..0x3FFFD).cover?(codepoint)    # CJK Unified Ideographs Extension (planes 2-3)
      )
    end

    def apply_padding(lines, width, padding)
      return lines if padding == 0

      padded = []

      padding.times { padded << " " * (width + padding * 2) }

      lines.each do |line|
        stripped_length = display_width(strip_ansi(line))
        spaces_needed = width - stripped_length
        padded << "#{' ' * padding}#{line}#{' ' * (spaces_needed + padding)}"
      end

      padding.times { padded << " " * (width + padding * 2) }

      padded
    end

    def strip_ansi(str)
      # More comprehensive ANSI escape sequence removal
      # Handles all CSI sequences, not just SGR (Select Graphic Rendition)
      str.gsub(/\e\[[^m]*m/, '')
    end
  end
end
