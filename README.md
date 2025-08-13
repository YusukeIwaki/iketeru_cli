# IketeruCli

IketeruCli is a Ruby library for building beautiful command-line applications with a simple, declarative syntax. Inspired by React and Ink, it brings component-based architecture and modern UI patterns to the terminal.

## Features

### 🎨 Rich Text Styling

- **Colors** - 16 basic colors, 256 colors, and true color (16 million colors) support
- **Text decorations** - Bold, italic, underline, strikethrough, dim, and inverse
- **Background colors** - Apply background colors to any text
- **Gradient text** - Smooth color gradients across text

### 📦 Component-Based Architecture

- **Composable components** - Build complex UIs from simple, reusable components
- **State management** - Built-in state handling with automatic re-rendering
- **Lifecycle methods** - Mount, update, and unmount hooks for components
- **Props system** - Pass data between components cleanly

### 🎯 Layout System

- **Flexbox-like layouts** - Arrange components with familiar flexbox properties
- **Box component** - Container with padding, margin, borders, and alignment
- **Grid layouts** - Create table-like structures easily
- **Responsive design** - Components that adapt to terminal size

### 🔤 Text Components

- **Text** - Basic text rendering with styling
- **Paragraph** - Multi-line text with word wrapping
- **List** - Ordered and unordered lists with custom markers
- **Table** - Data tables with headers, borders, and alignment
- **Spinner** - Loading indicators with various styles
- **Progress bar** - Visual progress indication

### ⌨️ Interactive Components

- **TextInput** - Single-line text input with validation
- **Select** - Single and multi-select menus
- **Confirm** - Yes/no prompts
- **Password** - Masked password input
- **Form** - Complex forms with multiple inputs

### 🎮 Input Handling

- **Keyboard events** - React to key presses, including special keys
- **Mouse support** - Click and hover events (terminal permitting)
- **Focus management** - Tab through interactive elements

### 🔄 Real-time Updates

- **Live rendering** - Automatic UI updates when state changes
- **Animations** - Smooth transitions and animations
- **Async support** - Handle asynchronous operations gracefully

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iketeru_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iketeru_cli

## Quick Start

```ruby
require 'iketeru_cli'

class Counter < IketeruCli::Component
  def initialize
    super
    @state = { count: 0 }
  end

  def mount
    on_key(' ') { set_state(count: @state[:count] + 1) }
    on_key('q') { exit_app }
  end

  def render
    box(border: :single, padding: 1) do
      text("Counter: #{@state[:count]}", color: :green, bold: true)
      text("Press SPACE to increment, Q to quit", color: :gray)
    end
  end
end

IketeruCli.render(Counter.new)
```

## More Examples

### Styled Text

```ruby
class HelloWorld < IketeruCli::Component
  def render
    text("Hello, ", color: :blue)
    text("World!", color: :magenta, bold: true, underline: true)
  end
end
```

### Interactive Menu

```ruby
class Menu < IketeruCli::Component
  def render
    select(label: "Choose your option:") do
      option("Start new game", value: :new_game)
      option("Load game", value: :load_game)
      option("Settings", value: :settings)
      option("Exit", value: :exit)
    end
  end
end
```

### Layout with Flexbox

```ruby
class Dashboard < IketeruCli::Component
  def render
    box(flex_direction: :row, height: "100%") do
      box(flex: 1, border: :single) do
        text("Sidebar", align: :center)
      end
      box(flex: 3, border: :single, padding: 1) do
        text("Main Content", align: :center)
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Terminal Behavior

By default the renderer now draws directly on the main screen buffer so that when you press Ctrl+C the final frame remains visible (similar to Ink / React behavior). If you prefer using the alternate screen buffer (content disappears after exit, keeping your scrollback clean) set:

```
IKETERU_CLI_ALT_SCREEN=1 bundle exec ruby examples/counter.rb
```

When the alternate screen is enabled the library will still copy the final frame back to the normal buffer on exit so you can see the last UI state.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/YusukeIwaki/iketeru_cli.
