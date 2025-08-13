# TypeScript/Ink vs Ruby/Rink Comparison

This directory contains TypeScript examples using the original Ink library for comparison with our Ruby Rink implementation.

## Setup

Install dependencies:
```bash
cd dev_examples
npm install
```

## Running Examples

### TypeScript Counter (Ink)
```bash
cd dev_examples
npm run counter
# or
./run_counter.sh
```

### Ruby Counter (Rink)
```bash
cd ..
bundle exec ruby examples/counter.rb
```

## Code Comparison

### TypeScript/Ink version:
```tsx
import React, { useState } from 'react';
import { render, Text, Box, useInput } from 'ink';

const Counter = () => {
  const [count, setCount] = useState(0);

  useInput((input, key) => {
    if (input === ' ') {
      setCount(count + 1);
    }
    if (input === 'q') {
      process.exit(0);
    }
  });

  return (
    <Box borderStyle="single" padding={1}>
      <Text color="green" bold>Counter: {count}</Text>
      <Text color="gray">Press SPACE to increment, Q to quit</Text>
    </Box>
  );
};

render(<Counter />);
```

### Ruby/Rink version:
```ruby
require 'rink'

class Counter < Rink::Component
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

Rink.render(Counter.new)
```

## Key Differences

1. **State Management**: 
   - Ink uses React hooks (`useState`)
   - Rink uses instance variables with `set_state`

2. **Event Handling**:
   - Ink uses `useInput` hook
   - Rink uses `on_key` method in `mount`

3. **Syntax**:
   - Ink uses JSX syntax
   - Rink uses Ruby blocks with DSL methods

4. **Component Structure**:
   - Ink uses functional components
   - Rink uses class-based components

Both achieve the same functionality with similar declarative approaches!