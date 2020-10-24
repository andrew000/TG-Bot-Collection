chcp 65001

$TOKEN = ""  # Enter token from https://t.me/BotFather
$URL = "https://api.telegram.org/bot$TOKEN"
$global:OFFSET = 0
$LIMIT = 5

function get_updates
{
    $response = Invoke-RestMethod -Uri "$URL/getUpdates?limit=$LIMIT&offset=$OFFSET"
    if ($response.ok -eq $false)
    {
        return $null
    }
    else
    {
        $updates = $response.result

        if ($null -ne $updates)
        {
            $global:OFFSET = $updates[-1].update_id + 1
            return $updates
        }

        else
        {
            return $null
        }
    }
}

function Bot
{
    while ($TRUE)
    {
        $updates = get_updates

        if ($null -ne $updates)
        {
            foreach ($update in $updates)
            {
                if ($null -ne $update.message.text)
                {
                    $chat_id = $update.message.chat.id
                    $echo_text = $update.message.text
                    Invoke-RestMethod -Method Post -Uri "$URL/sendMessage?chat_id=$chat_id&text=$echo_text"
                }
            }
        }

        Start-Sleep 0.5
    }
}

Bot