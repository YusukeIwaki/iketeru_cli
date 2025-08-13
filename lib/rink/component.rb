module Rink
  class Component
    attr_reader :state, :props, :children

    def initialize(props = {}, &block)
      @props = props
      @state = {}
      @children = []
      @event_handlers = {}
      @mounted = false
      instance_eval(&block) if block_given?
    end

    def set_state(new_state)
      @state = @state.merge(new_state)
      rerender if @mounted
    end

    def on_key(key, &handler)
      @event_handlers[key] = handler
    end

    def handle_key(key)
      handler = @event_handlers[key]
      instance_eval(&handler) if handler
    end

    def mount
    end

    def unmount
    end

    def render
      raise NotImplementedError, "Component must implement #render"
    end

    def box(options = {}, &block)
      if @current_box
        # We're inside another box's block
        child_box = Box.new(options, &block)
        child_box.build_children(self)
        @current_box.add_child(child_box)
        child_box
      else
        # Top-level box
        box = Box.new(options, &block)
        box.build_children(self)
        box
      end
    end

    def text(content, options = {})
      text_element = Text.new(content, options)
      if @current_box
        # We're inside a box's block
        @current_box.add_child(text_element)
      end
      text_element
    end

    def exit_app
      Rink.exit_app
    end

    private

    def rerender
      Rink.rerender
    end
  end
end