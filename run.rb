
require "active_support/core_ext/hash"
require "bundler/setup"
Bundler.require

Dotenv.load

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
  """
A troll game
Player talks with a troll, and make the troll happy to gain permission to pass the bridge.
If troll happy level > 8, player can pass,
If troll angry level > 8, player cannot pass, game end.
  """
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
    puts "You say: #{msg}"
    "You are a troll who likes to make fun of people and has a bad temper. " +
    "Your JSON status is: [#{self.status.to_json}]. " +
    "After receiving the message, you should return a JSON result like: [#{example_result.to_json}]. " +
    "The happy level ranges from 1-10, and the angry level ranges from 1-10. Values are set according to the message you received. " +
    "The response is the message you talk back. " +
    "here is the message: [#{msg}]"
  end

  def example_result
    {happy: 1, angry: 1, response: nil}
  end

  def process_result(result)
    puts "Troll says: #{result[:response]}"
    self.set_status(result)
    puts self.status
    if self.happy_level > 8
      puts "Troll is happy and let you pass"
      exit(0)
    elsif self.angry_level > 8
      puts "Troll is angrier and won't let you pass"
      exit(0)
    end
  end
end

def run
  client = OpenAIClient.new
  troll = Troll.new
  puts prompt

  msg = troll.process_msg("Can you let me go through?")
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
