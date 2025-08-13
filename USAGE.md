# Testing the Interactive Counter

The display issues have been fixed! Here's how to test the interactive counter:

## Method 1: Direct Run (Recommended)
Open a terminal and run:
```bash
bundle exec ruby examples/counter.rb
```

Then:
- Press SPACE to increment the counter
- Press Q to quit

## Method 2: Simple Test
If you want to quickly verify the display without interaction:
```bash
bundle exec ruby examples/test_counter.rb
```

## Method 3: Auto-exiting Test
For a quick visual check:
```bash
bundle exec ruby examples/quick_counter_test.rb
```

## If Display Issues Persist
If you still see display corruption, use ASCII borders instead:

1. Edit `examples/counter.rb`
2. Change `border: :single` to `border: :ascii`

The ASCII version uses `+`, `-`, and `|` characters instead of Unicode box-drawing characters.

## Troubleshooting
- Make sure your terminal supports UTF-8 encoding
- Try different terminal emulators if issues persist
- Use the `:ascii` border style for maximum compatibility