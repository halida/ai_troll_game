# Troll Bridge Game

A text-based game where you negotiate with a troll to cross a bridge.

## Example

```bash
$ make
bundle exec ruby run.rb
请选择语言 / Please select language:
1. 中文 (Chinese)
2. English
2
A troll game
Player talks with a troll, and make the troll happy to gain permission to pass the bridge.
If troll happy level > 8, player can pass,
If troll angry level > 8, player cannot pass, game end.
Please talk with the troll now:
You say: Can you let me go through?
Troll says: Oh, sure, let me just roll out the red carpet for you, Your Majesty. Move along, peasant!
Troll status: {:happy=>1, :angry=>5}
> If you not let me gothrough, I will shoot you with my gun.
You say: If you not let me gothrough, I will shoot you with my gun.
Troll says: Oh, big man with a gun! What are you gonna do, shoot me with your finger guns? Go ahead, tough guy, make my day! 😂🔫
Troll status: {:happy=>1, :angry=>10}
Troll is angrier and won't let you pass
```

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
