# Author https://github.com/andrew000

require "http/client"
require "json"


TOKEN = ""  # Enter token from https://t.me/BotFather
URL = "https://api.telegram.org/bot#{TOKEN}"
LIMIT = 5



def get_updates(offset : Int32)
  params = HTTP::Params.encode({"offset" => "#{offset}", "limit" => "#{LIMIT}"})
  response = HTTP::Client.get("#{URL}/getUpdates?" + params)
  response = JSON.parse(response.body)

  return response["result"]
end


def send_message(update)
  chat_id = update["message"]["chat"]["id"]
  echo_text = update["message"]["text"]

  params = HTTP::Params.encode({"chat_id" => "#{chat_id}", "text" => "#{echo_text}"})
  response = HTTP::Client.post("#{URL}/sendMessage?" + params)
  response = JSON.parse(response.body)

  return response
end


def main()
  offset : Int32 = 0

  while true
    updates = get_updates(offset)

    if updates != Nil && !updates.as_a.empty?
      offset = updates[updates.size-1]["update_id"].as_i + 1
      
      updates.as_a.each do |update|
        if update["message"]? || !!update["message"]["text"]?
          send_message(update)
        else
          next
        end
      end
    end    
  end
end

main()
