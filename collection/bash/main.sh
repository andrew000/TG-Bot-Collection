# Author: https://github.com/andrew000

TOKEN=""  # Enter token from https://t.me/BotFather
URL="https://api.telegram.org/bot$TOKEN"
LIMIT=1 # BASH can't work with List, so limit must be 1
OFFSET=0

function get_update() {
  response=$(curl -s -X GET -G "$URL/getUpdates" -d limit=$LIMIT -d offset=$OFFSET)

  if [[ $(echo "$response" | jq -r '.result[-1]') == 'null' ]]; then
    return 0
  fi

  OK=$(echo "$response" | jq -r '.ok')
  if [[ $OK == 'false' ]]; then
    return 0
  fi

  OFFSET=$(($(echo "$response" | jq -r '.result[-1].update_id') + 1))
  chat_id=$(echo "$response" | jq -r '.result[-1].message.chat.id')
  echo_text=$(echo "$response" | jq -r '.result[-1].message.text')

  if [[ $echo_text == 'null' ]]; then
    return 0
  fi

  curl -s -m 2 -X POST "$URL/sendMessage" -d chat_id="$chat_id" -d text="$echo_text"
}

while true; do
  get_update
done
