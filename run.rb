require "active_support/core_ext/hash"
require "bundler/setup"
Bundler.require
require "i18n"

Dotenv.load

# Configure I18n
I18n.load_path = Dir[File.expand_path("locales") + "/*.yml"]
I18n.default_locale = :en

def select_language
  puts "请选择语言 / Please select language:"
  puts "1. 中文 (Chinese)"
  puts "2. English"
  choice = gets.chomp
  case choice
  when '1'
    I18n.locale = :zh
  else
    I18n.locale = :en
  end
end

class OpenAIClient
  def initialize
    @client = OpenAI::Client.new(
      uri_base: ENV.fetch('URI_BASE'),
      access_token: ENV.fetch('ACCESS_TOKEN'),
      log_errors: true,
    )
  end

  def chat(message)
    response = @client.chat(
      parameters: {
        model: "deepseek-chat",
        messages: [{ role: "user", content: message }],
        temperature: 0.7,
      }
    )

    if response["error"]
      raise "API Error: #{response["error"]["message"]}"
    end

    content = response.dig("choices", 0, "message", "content").gsub("```", "").gsub("json", "")
    v = JSON.parse(content)
    v = v[0] if v.kind_of?(Array)
    v.with_indifferent_access
  end
end

def prompt
  I18n.t('troll_game.prompt')
end

class Troll
  attr_accessor :happy_level, :angry_level

  def initialize
    self.happy_level = 1
    self.angry_level = 1
  end

  def status
    {happy: happy_level, angry: angry_level}
  end

  def set_status(status)
    self.happy_level = status[:happy]
    self.angry_level = status[:angry]
  end
  
  def process_msg(msg)
    puts I18n.t('troll_game.messages.you_say', message: msg)
    [
      I18n.t('troll_game.instructions.troll_description'),
      I18n.t('troll_game.instructions.status_description', status: self.status.to_json),
      I18n.t('troll_game.instructions.result_description', example: example_result.to_json),
      I18n.t('troll_game.instructions.level_ranges'),
      I18n.t('troll_game.instructions.response_description'),
      I18n.t('troll_game.instructions.message_prompt', message: msg)
    ].join(" ")
  end

  def example_result
    {happy: 1, angry: 1, response: nil}
  end

  def process_result(result)
    puts I18n.t('troll_game.messages.troll_says', message: result[:response])
    self.set_status(result)
    puts I18n.t('troll_game.messages.status', status: self.status)
    if self.happy_level > 8
      puts I18n.t('troll_game.messages.happy_pass')
      exit(0)
    elsif self.angry_level > 8
      puts I18n.t('troll_game.messages.angry_block')
      exit(0)
    end
  end
end

def run
  select_language
  client = OpenAIClient.new
  troll = Troll.new
  puts prompt

  msg = troll.process_msg(I18n.t('troll_game.initial_message'))
  result = client.chat(msg)
  troll.process_result(result)

  while true
    print "> "
    msg = readline
    msg = troll.process_msg(msg)

    begin
      result = client.chat(msg)
      troll.process_result(result)
    rescue => e
      raise e
    end
  end
end

run
