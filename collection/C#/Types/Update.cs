using Newtonsoft.Json;

namespace TG_Bot.Types
{
    internal class Update
    {
        [JsonProperty("update_id", Required = Required.Always)]
        public int Id { get; set; }

        [JsonProperty("message")] 
        public Message Message { get; set; }
    }
}