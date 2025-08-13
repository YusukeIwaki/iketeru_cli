require "iketeru_cli/version"
require "iketeru_cli/terminal"
require "iketeru_cli/text"
require "iketeru_cli/box"
require "iketeru_cli/component"
require "iketeru_cli/renderer"

module IketeruCli
  class Error < StandardError; end
  
  class << self
    attr_accessor :current_renderer

    def render(component)
      @current_renderer = Renderer.new(component)
      @current_renderer.start
    end

    def rerender
      @current_renderer&.rerender
    end

    def exit_app
      @current_renderer&.stop
    end
  end
end
