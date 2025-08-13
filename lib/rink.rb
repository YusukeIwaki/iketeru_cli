require "rink/version"
require "rink/terminal"
require "rink/text"
require "rink/box"
require "rink/component"
require "rink/renderer"

module Rink
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
