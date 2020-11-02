<?php

// Author https://github.com/andrew000

require('vendor/autoload.php');

use Symfony\Component\HttpClient\HttpClient;


$TOKEN = ""; // Enter token from https://t.me/BotFather
$URL = "https://api.telegram.org/bot$TOKEN";
$OFFSET = 0;
$LIMIT = 5;


function get_updates($URL, $LIMIT, $OFFSET)
{
    $httpClient = HttpClient::create();
    $response = $httpClient->request("GET", "$URL/getUpdates", [
        "headers" => [
            "Content-Type" => "application/json"
        ],
        "query" => [
            "limit" => "$LIMIT",
            "offset" => "$OFFSET",
        ]
    ]);
    $content = $response->getContent();
    $content = json_decode($content, true);
    return $content["result"];
}


function send_message($URL, $update)
{
    $chat_id = $update['message']['chat']['id'];
    $echo_text = $update['message']['text'];

    $httpClient = HttpClient::create();
    $response = $httpClient->request("POST", "$URL/sendMessage", [
        "body" => [
            "chat_id" => $chat_id,
            "text" => $echo_text,
        ]
    ]);

    return $response->getContent();
}

while (true) {
    global $OFFSET;
    $updates = get_updates($URL, $LIMIT, $OFFSET);
    $OFFSET = $updates[count($updates) - 1]['update_id'] + 1;

    foreach ($updates as $update) {
        if ($update['message'] and $update['message']['text']) {
            send_message($URL, $update);
        }
    }
}