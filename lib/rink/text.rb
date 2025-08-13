module Rink
  class Text
    attr_reader :content, :options

    COLORS = {
      black: 30,
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36,
      white: 37,
      gray: 90,
      grey: 90
    }.freeze

    BACKGROUND_COLORS = {
      black: 40,
      red: 41,
      green: 42,
      yellow: 43,
      blue: 44,
      magenta: 45,
      cyan: 46,
      white: 47
    }.freeze

    def initialize(content, options = {})
      @content = content.to_s
      @options = options
    end

    def render
      styled_content
    end

    def to_s
      render
    end

    private

    def styled_content
      codes = []
      
      codes << COLORS[options[:color]] if options[:color]
      codes << BACKGROUND_COLORS[options[:background]] if options[:background]
      codes << 1 if options[:bold]
      codes << 3 if options[:italic]
      codes << 4 if options[:underline]
      codes << 9 if options[:strikethrough]
      codes << 2 if options[:dim]
      codes << 7 if options[:inverse]
      
      if codes.empty?
        content
      else
        "\e[#{codes.join(';')}m#{content}\e[0m"
      end
    end
  end
end