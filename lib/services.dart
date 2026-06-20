import 'dart:convert';

import 'package:http/http.dart' as http;

class apiintegration {
  static String apikey =
      "";
  static String apilink = "";

  Future<String> apiConnection(List<Map<String, String>> messages) async {
    try {
      final Response = await http.post(
        Uri.parse(apilink),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apikey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": messages,
        }),
      );

      if (Response.statusCode == 200) {
        final data = jsonDecode(Response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "error";
      }
    } catch (e) {
      return "$e";
    }
  }
}
