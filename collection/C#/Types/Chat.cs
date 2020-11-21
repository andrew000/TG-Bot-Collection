using Newtonsoft.Json;

namespace TG_Bot.Types
{
    public class Chat
    {
        [JsonProperty("id")] public int Id { get; set; }
    }
}