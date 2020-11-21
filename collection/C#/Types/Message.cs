using Newtonsoft.Json;

namespace TG_Bot.Types
{
    public class Message
    {
        [JsonProperty("message_id")] public int MessageId { get; set; }
        [JsonProperty("chat")] public Chat Chat { get; set; }
        [JsonProperty("text")] public string Text { get; set; }
    }
}