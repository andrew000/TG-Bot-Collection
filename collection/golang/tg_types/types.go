package tg_types

type Chat struct {
	Id int32 `json:"id"`
}

type Message struct {
	MessageId int32  `json:"message_id"`
	Chat      Chat   `json:"chat"`
	Text      string `json:"text"`
}

type Update struct {
	UpdateId int32  `json:"update_id"`
	Message  Message `json:"message"`
}

type Response struct {
	Ok     bool     `json:"ok"`
	Result []Update `json:"result"`
}
