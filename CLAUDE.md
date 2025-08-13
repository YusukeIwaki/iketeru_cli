# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rink is a Ruby library for building beautiful command-line applications with a declarative, component-based syntax. It's inspired by React and Ink (JavaScript), bringing modern UI patterns to terminal applications.

## Coding Conventions

### Method Call Style
- **Always use parentheses for method calls with arguments**: `text("Hello", color: :blue)`
- **Omit parentheses only when there are no arguments**: `render` or `super`
- This applies to all DSL methods like `text()`, `box()`, `option()`, etc.

### Code Style
- Follow Ruby standard conventions
- Use symbols for option keys and enum values
- Prefer keyword arguments for configuration options

## Commands

### Setup and Dependencies
- `bin/setup` - Initial setup: installs dependencies via bundler
- `bundle install` - Install gem dependencies

### Testing
- `rake spec` - Run all RSpec tests
- `bundle exec rspec` - Run all tests with bundler context
- `bundle exec rspec spec/rink_spec.rb` - Run specific test file
- `bundle exec rspec spec/rink_spec.rb:10` - Run test at specific line

### Development
- `bin/console` - Interactive Ruby console with gem loaded for experimentation
- `bundle exec rake install` - Install gem onto local machine
- `bundle exec rake build` - Build the gem package

### Release
- `bundle exec rake release` - Create git tag, push commits/tags, and push gem to rubygems.org (requires version bump in lib/rink/version.rb)

## Architecture

This is a Ruby gem for building CLI applications with component-based architecture:

- **lib/rink.rb** - Main entry point for the gem, requires version and defines the Rink module with base Error class
- **lib/rink/** - Directory for additional Ruby modules and classes
- **lib/rink/version.rb** - Defines gem version constant (Rink::VERSION)
- **spec/** - RSpec test suite with spec_helper.rb configuration
- **rink.gemspec** - Gem specification defining dependencies, metadata, and packaging

### Key Design Principles
- Component-based architecture similar to React
- Declarative syntax for building UIs
- State management with automatic re-rendering
- Rich text styling and layout capabilities
- Interactive components for user input

The gem uses:
- RSpec ~> 3.0 for testing
- Bundler ~> 1.17 for dependency management
- Rake ~> 10.0 for task automation

Test configuration persists example status in `.rspec_status` and disables RSpec monkey patching for cleaner testing.