# Testing IketeruCli

## Running Tests

Run the test suite:
```bash
bundle exec rspec
```

## Testing the Counter Example

### Interactive Mode
To run the interactive Counter example:
```bash
ruby examples/counter.rb
```

- Press SPACE to increment the counter
- Press Q to quit

### Non-Interactive Test
To test the Counter without terminal interaction:
```bash
ruby examples/test_counter.rb
```

This will show the Counter rendering with different states.

## Creating Your Own Component

Create a new file and require IketeruCli:

```ruby
require 'bundler/setup'
require 'iketeru_cli'

class MyApp < IketeruCli::Component
  def initialize
    super
    @state = { message: "Hello, IketeruCli!" }
  end
  
  def render
    box(border: :round, padding: 2) do
      text(@state[:message], color: :cyan, bold: true)
    end
  end
end

IketeruCli.render(MyApp.new)
```