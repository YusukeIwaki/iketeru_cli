module IketeruCli
  class Renderer
    attr_reader :component

    def initialize(component)
      @component = component
      @running = false
  @previous_height = 0
  @rendered_once = false
    end

    def start
      @running = true

      Terminal.hide_cursor
      Terminal.enable_raw_mode
  @use_alt_screen = ENV['IKETERU_CLI_ALT_SCREEN'] == '1'
  Terminal.enter_alt_screen if @use_alt_screen
  if @use_alt_screen
    Terminal.clear
    Terminal.move_cursor(1, 1)
  end
      STDOUT.sync = true

      @component.mount if @component.respond_to?(:mount)
      @component.instance_variable_set(:@mounted, true)

      render_loop
    ensure
      cleanup
    end

    def stop
      @running = false
    end

    def rerender
      return unless @running
      output = @component.render

      rendered_content = if output.respond_to?(:render)
        output.render
      elsif output.is_a?(String)
        output
      elsif output.is_a?(Array)
        output.map { |item| item.respond_to?(:render) ? item.render : item }.join("\n")
      else
        output.to_s
      end

      lines = rendered_content.split("\n")
      height = lines.size

      if @rendered_once && STDOUT.tty?
        # 前回フレームの最終行末にカーソルがあるため、上に戻るのは (高さ - 1) 行で十分
        if @previous_height > 1
          print "\e[#{@previous_height - 1}A" # move up h-1 lines
        end
        # 先頭列へ
        print "\r"
      else
        # 初回は現カーソル位置に上書きするのみ（clear しない）
      end

      max_lines = [@previous_height, height].max
      (0...max_lines).each do |i|
        line = lines[i] || ''
        # \r reset to column 1, print line, clear remainder of that line  
        if STDOUT.tty?
          print "\r#{line}\e[K"
        else
          print line
        end
        # Print newline after every line except the last visual row
        print "\n" unless i == max_lines - 1
      end

      @previous_height = height
      @rendered_once = true
      @last_rendered_content = lines.join("\n")

      if ENV['RINK_DEBUG'] == '1'
        term_w = Terminal.size[:width]
        STDERR.puts "[RINK DEBUG] term_width=#{term_w} lines=#{lines.size} prev_height=#{@previous_height}"
        lines.each_with_index do |line, idx|
          raw_len = line.length
          disp_len = debug_display_width(line)
            STDERR.puts sprintf('[RINK DEBUG] line=%02d raw=%d display=%d %s', idx, raw_len, disp_len, line.gsub("\e", '␛'))
        end
      end
      STDOUT.flush
      return
    end

    private

    def render_loop
      rerender

      while @running
        key = Terminal.read_key

        case key
        when :ctrl_c, :ctrl_d
          stop
        when :escape
          # ESC key - try component handler first, then exit if not handled
          if @component.respond_to?(:handle_key)
            @component.handle_key(key)
          else
            stop  # Default ESC behavior: exit
          end
        else
          @component.handle_key(key) if @component.respond_to?(:handle_key)
        end
      end
    end

    def cleanup
      @component.unmount if @component.respond_to?(:unmount)
      @component.instance_variable_set(:@mounted, false)
      # 非 alt screen: プロンプトが枠の直後に続かないよう 1 行だけ改行を入れる
      unless @use_alt_screen
        # raw mode では "\n" が CR を伴わないため LF だけだと列位置が保持される
        # 明示的に CRLF を出力して次行の先頭へ移動
        print "\r\n"
      end
      Terminal.show_cursor
      Terminal.disable_raw_mode
      if @use_alt_screen
        # Leave alt screen then print last frame so it persists in normal buffer
        Terminal.leave_alt_screen
        if @last_rendered_content && !@last_rendered_content.empty?
          puts @last_rendered_content
        end
      end
    end

    def debug_display_width(str)
      # Strip ANSI
      s = str.gsub(/\e\[[^m]*m/, '')
      width = 0
      s.each_char do |ch|
        code = ch.ord
        if code <= 0x1F || (code >= 0x7F && code <= 0x9F)
          next
        elsif (
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
          width += 2
        else
          width += 1
        end
      end
      width
    end
  end
end
