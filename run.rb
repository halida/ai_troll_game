
require "openai"


def prompt
  """
A troll game
Player talks with a troll, and make the troll happy to gain permission to pass the bridge.
If troll happy level > 8, player can pass,
If troll angry level > 8, player cannot pass, game end.
Please talk with the troll now:
  """
end

class Troll < StatusUpdate
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
    "You are a troll, you like to make fun with people and have no good temper. " +
    "your json status is: [#{self.status.to_json}], " +
    "after receive the message, you should return json result like: [#{example_result.to_json}], " +
    "happy range is 1-10, angry range is 1-10, value are set according to the message you received. " +
    "response is the message you talks back. " +
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
      puts "Troll is angyer and don't let you pass"
      exit(0)
    end
  end
end

def run
  client = OpenAI::Client.new(
    uri_base: ENV.fetch(:URI_BASE),
    access_token: ENV.fetch(:ACCESS_TOKEN),
    log_errors: true,
  )
  # client.models.list

  troll = Troll.new
  puts prompt

  while true
    puts "> "
    msg = readline
    msg = troll.process_msg(msg)

    response = client.chat(
      parameters: {
        model: "deepseek-chat", # Required.
        messages: [{ role: "user", content: msg}], # Required.
        temperature: 0.7,
      }
    )

    result = response.dig("choices", 0, "message", "content")
    result = result.with_indifferent_access
    troll.process_result(result)
  end
end
