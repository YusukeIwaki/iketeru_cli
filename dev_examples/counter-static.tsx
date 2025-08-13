#!/usr/bin/env tsx

import React from 'react';
import { render, Text, Box } from 'ink';

const StaticCounter = () => {
  return (
    <Box borderStyle="single" padding={1} flexDirection="column">
      <Text color="green" bold>Counter: 0</Text>
      <Text color="gray">Press SPACE to increment, Q to quit</Text>
    </Box>
  );
};

// Render for 1 second then exit
render(<StaticCounter />);

setTimeout(() => {
  process.exit(0);
}, 1000);