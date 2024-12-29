# Troll Bridge Game

A text-based game where you negotiate with a troll to cross a bridge.

## Features
- Interactive conversation with a troll
- Multiple language support (English and Chinese)
- Dynamic emotional responses from the troll
- Simple text-based interface

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Copy `.env.example` to `.env` and fill in your OpenAI API credentials

## Usage

Run the game:
```bash
make
```

Follow the on-screen instructions to play the game.

## Language Support

The game supports both English and Chinese. You'll be prompted to select your preferred language when starting the game.

## Configuration

The game requires the following environment variables in `.env`:
- `URI_BASE`: Base URL for the OpenAI API
- `ACCESS_TOKEN`: Your OpenAI API access token

## Dependencies

- ruby-openai
- dotenv-rails
- activesupport
- i18n

## License

MIT License
