const axios = require("axios");

// Author: https://github.com/andrew000


let TOKEN = "";  // Enter token from https://t.me/BotFather
let URL = "https://api.telegram.org/bot" + TOKEN;
let LIMIT = 5
let OFFSET = 0;

async function process_updates(updates) {
    if (updates.length === 0) {
        return null;
    }

    OFFSET = updates[updates.length - 1]['update_id'] + 1;

    for (let update of updates) {
        if (update['message']['text']) {
            let chat_id = update['message']['chat']['id'];
            let echo_text = update['message']['text'];
            await axios.post(URL + "/sendMessage", {chat_id: chat_id, text: echo_text})
            console.log(update['message']['text'])
        }
    }
}

async function get_updates() {
    axios.get(URL + "/getUpdates", {
        params: {
            limit: LIMIT,
            offset: OFFSET,
        }
    }).then(async response => {
        if (response.data.ok === true) {
            await process_updates(response.data.result)
        }
    }).catch(function (error) {
        return error
    });
}


setInterval(async function () {
    await get_updates()
}, 500)