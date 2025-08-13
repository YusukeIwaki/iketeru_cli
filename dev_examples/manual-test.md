# Manual Testing Instructions

## TypeScript/Ink Counter

The TypeScript counter needs to run in a real terminal (not through command pipes) to work properly.

### Method 1: Direct Terminal Run
1. Open a new terminal window
2. Navigate to the dev_examples directory:
   ```bash
   cd dev_examples
   ```
3. Run the interactive counter:
   ```bash
   npx tsx counter.tsx
   ```

### Method 2: Static Display Test
To see the visual appearance without interaction:
```bash
npm run counter-static
```

### Expected Output

Both Ruby and TypeScript versions should display:

```
┌─────────────────────────────────────┐
│                                     │
│ Counter: 0                          │
│ Press SPACE to increment, Q to quit │
│                                     │
└─────────────────────────────────────┘
```

### Comparison Results

- **Layout**: Both versions produce identical box layouts
- **Styling**: Both support colors and text formatting
- **Interaction**: Both use similar key handling patterns
- **Syntax**: TypeScript uses JSX, Ruby uses block DSL

The Ruby Rink implementation successfully replicates the Ink behavior!