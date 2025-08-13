#!/usr/bin/env tsx

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
    <Box borderStyle="single" padding={1} flexDirection="column">
      <Text color="green" bold>Counter: {count}</Text>
      <Text color="gray">Press SPACE to increment, Q to quit</Text>
    </Box>
  );
};

render(<Counter />);