import axios from "axios";

// Author: https://github.com/andrew000

let TOKEN: string = "";  // Enter token from https://t.me/BotFather
let TG_URL: string = `https://api.telegram.org/bot${TOKEN}`;
let OFFSET: number = 0;
const LIMIT: number = 5

function process_updates(updates: Array<any>) {
    if (updates.length === 0) {
        return null;
    }

    OFFSET = updates[updates.length - 1]['update_id'] + 1;

    for (let update of updates) {
        if (update['message']['text']) {
            let chat_id = update['message']['chat']['id'];
            let echo_text = update['message']['text'];
            axios.post(TG_URL + "/sendMessage", {chat_id: chat_id, text: echo_text})
            console.log(update['message']['text'])
        }
    }
}

function get_updates() {
    axios.get(TG_URL + "/getUpdates", {
        params: {
            limit: LIMIT,
            offset: OFFSET,
        }
    }).then(response => {
        if (response.data.ok === true) {
            process_updates(response.data.result)
        }
    }).catch(function (error) {
        return error
    });
}


setInterval(function () {
    get_updates()
}, 500)