import json

import requests

TOKEN = ""  # Enter token from https://t.me/BotFather
URL = f"https://api.telegram.org/bot{TOKEN}"
OFFSET = 0
LIMIT = 5


def get_updates():
    global OFFSET
    response = requests.get(url=f"{URL}/getUpdates", params={'limit': LIMIT, 'offset': OFFSET})
    update = json.loads(response.text)['result']
    if update:
        OFFSET = update[-1]['update_id'] + 1
        return update
    else:
        return None


def main():
    while True:
        last_update = get_updates()
        if not last_update:
            continue

        for update in last_update:
            try:
                chat_id = update['message']['chat']['id']
                echo_text = update['message']['text']
                requests.post(url=f"{URL}/sendMessage", data={'chat_id': chat_id, 'text': echo_text})

            except KeyError:
                continue


if __name__ == "__main__":
    main()
