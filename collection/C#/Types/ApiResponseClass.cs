using System.Collections.Generic;
using Newtonsoft.Json;

namespace TG_Bot.Types
{
    internal class ApiResponseClass
    {
        [JsonProperty("ok", Required = Required.Always)]
        public bool Ok { get; set; }

        [JsonProperty("result")] public List<Update> Result { get; set; }

        [JsonProperty("error_code")] public int ErrorCode { get; set; }
        [JsonProperty("description")] public int Description { get; set; }
    }
}