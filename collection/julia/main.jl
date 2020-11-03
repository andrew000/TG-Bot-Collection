import Pkg
Pkg.add("HTTP")
Pkg.add("JSON")

# Author https://github.com/andrew000

using HTTP
using JSON

TOKEN = ""  # Enter token from https://t.me/BotFather
URL = "https://api.telegram.org/bot$TOKEN"
OFFSET = 0
LIMIT = 5

function get_updates(offset, limit)
	params = Dict("offset" => offset, "limit" => limit)

    response = HTTP.request(
        "GET",
        "$URL/getUpdates",
        ["Content-Type" => "application/json"],
        JSON.json(params))

    return JSON.parse(String(response.body))["result"]
end


function send_message(update)
	if !("message" in keys(update)) || !("text" in keys(update["message"]))
		return
    end

    chat_id = update["message"]["chat"]["id"]
    echo_text = update["message"]["text"]

	params = Dict("chat_id" => chat_id, "text" => echo_text)

    HTTP.request(
        "POST",
        "$URL/sendMessage",
        ["Content-Type" => "application/json"],
		JSON.json(params))
end


while true
    updates = get_updates(OFFSET, LIMIT)

	if length(updates) != 0
		global OFFSET = updates[length(updates)]["update_id"] + 1

        for update in updates
		    send_message(update)
        end
	end
	Base.sleep(0.5)
end