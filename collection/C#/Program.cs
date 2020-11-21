using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;
using TG_Bot.Types;

// https://github.com/andrew000

namespace TG_Bot
{
    public static class ProcessUpdatesClass
    {
        public static async Task ProcessApiRequest(string responseBody)
        {
            var response = JsonConvert.DeserializeObject<ApiResponseClass>(responseBody);

            if (response.Ok is false)
            {
                return;
            }

            if (response.Result.Count <= 0)
            {
                return;
            }


            Bot.Offset = response.Result.Last().Id + 1;
            foreach (var update in response.Result.Where(update => update.Message?.Text != null))
            {
                await Bot.SendMessage(update.Message.Chat.Id, update.Message.Text);
            }
        }
    }

    internal static class Program
    {
        public static async Task Main()
        {
            const string token = ""; // Enter token from https://t.me/BotFather
            var bot = new Bot(token, 5);

            while (true)
            {
                await ProcessUpdatesClass.ProcessApiRequest(await Bot.GetUpdates());
                Thread.Sleep(100);
            }
        }
    }
}