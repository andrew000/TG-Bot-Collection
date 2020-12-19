package main

// Author https://github.com/andrew000

import (
	"./tg_types"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
)

const TOKEN = "" // Enter token from https://t.me/BotFather
const URL = "https://api.telegram.org/bot" + TOKEN
const LIMIT int32 = 5

var OFFSET int32 = 0

func getUpdates(offset int32) []tg_types.Update {
	data := url.Values{
		"offset": {fmt.Sprint(offset)},
		"limit":  {fmt.Sprint(LIMIT)}}

	resp, err := http.PostForm(fmt.Sprintf("%s/getUpdates", URL), data)

	if err != nil {
		log.Fatalln(err)
	}

	body, err := ioutil.ReadAll(resp.Body)

	var response tg_types.Response
	json.Unmarshal(body, &response)

	return response.Result

}

func processUpdate(update tg_types.Update) bool {
	if update.Message.Text == "" {
		return false
	}

	data := url.Values{
		"chat_id": {fmt.Sprint(update.Message.Chat.Id)},
		"text":    {update.Message.Text}}

	_, err := http.PostForm(fmt.Sprintf("%s/sendMessage", URL), data)

	if err != nil {
		log.Fatalln(err)
	}
	return true

}

func main() {

	for true {
		var updates = getUpdates(OFFSET)
		if len(updates) == 0 {
			continue
		}
		OFFSET = updates[len(updates)-1].UpdateId + 1

		for _, update := range updates {
			processUpdate(update)
		}
	}
}
