using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace TG_Bot.Types
{
    public class Bot
    {
        private string Token { get; }
        private static int Limit { get; set; }
        private static string Url { get; set; }
        public static int Offset { get; set; }
        private static HttpClient BotClient { get; set; }


        public Bot(string token, int limit)
        {
            Token = token;
            Limit = limit;
            Url = $"https://api.telegram.org/bot{Token}";
            Offset = 0;
            BotClient = new HttpClient();
        }


        public static async Task<string> SendMessage(int chatId, string text)
        {
            var query = new FormUrlEncodedContent(
                new Dictionary<string, string>
                {
                    {"chat_id", chatId.ToString()},
                    {"text", text}
                });


            var response = await BotClient.PostAsync($"{Url}/sendMessage", query);
            return await response.Content.ReadAsStringAsync();
        }

        public static async Task<string> GetUpdates()
        {
            var query = new FormUrlEncodedContent(
                new Dictionary<string, string>
                {
                    {"limit", Limit.ToString()},
                    {"offset", Offset.ToString()}
                });

            var response = await BotClient.PostAsync($"{Url}/getUpdates", query);
            return await response.Content.ReadAsStringAsync();
        }
    }
}