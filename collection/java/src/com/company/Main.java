package com.company;

import com.google.gson.Gson;
import org.apache.http.client.utils.URIBuilder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;


class Chat {
    public long id;
    public String title;
    public String username;
    public String type;
}


class User {
    public long id;
    public boolean is_bot;
    public String first_name;
    public String last_name;
    public String username;
}


class Message {
    public long message_id;
    public User from;
    public Chat chat;
    public long date;
    public String text;
}

class Update {
    public int update_id;
    public Message message;
}

class Response {
    public boolean ok;
    public ArrayList<Update> result;

}

public class Main {
    final static String TOKEN = "";  // Enter token from https://t.me/BotFather
    final static long LIMIT = 5;
    static long OFFSET = 0;

    public static Response get_updates() {
        URIBuilder builder = new URIBuilder();
        builder.setScheme("https");
        builder.setHost("api.telegram.org");
        builder.setPath(String.format("bot%s/getUpdates", TOKEN));
        builder.addParameter("offset", String.valueOf(OFFSET));
        builder.addParameter("limit", String.valueOf(LIMIT));
        HttpURLConnection connection = null;

        try {
            URL url = builder.build().toURL();
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setUseCaches(false);
            connection.setDoOutput(true);

            InputStream is = connection.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is));
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            rd.close();
            Gson g = new Gson();


            return g.fromJson(response.toString(), Response.class);

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        return null;
    }

    public static void process_update(Response response) {
        ArrayList<Update> updates = response.result;

        if (!updates.isEmpty()) {
            OFFSET = updates.get(updates.size() - 1).update_id + 1;

            for (Update update : updates) {
                if (update.message == null || update.message.text == null) {
                    continue;
                }
                long chat_id = update.message.chat.id;
                String echo_text = update.message.text;

                URIBuilder builder = new URIBuilder();
                builder.setScheme("https");
                builder.setHost("api.telegram.org");
                builder.setPath(String.format("bot%s/sendMessage", TOKEN));
                builder.addParameter("chat_id", String.valueOf(chat_id));
                builder.addParameter("text", echo_text);
                HttpURLConnection connection = null;

                try {
                    URL url = builder.build().toURL();
                    connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("POST");
                    connection.setUseCaches(false);
                    connection.setDoOutput(true);
                    connection.getInputStream();

                } catch (IOException | URISyntaxException e) {
                    e.printStackTrace();

                } finally {
                    if (connection != null) {
                        connection.disconnect();
                    }
                }
            }
        }
    }

    public static void main(String[] args) {
        while (true) {
            try {
                Response response = get_updates();
                assert response != null;
                process_update(response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
