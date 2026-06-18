import 'dart:convert';
import 'dart:io';

class FirebaseRestService {
  FirebaseRestService._();

  static const String _databaseUrl =
      'https://iot-2026-tharuka-default-rtdb.firebaseio.com';

  static Future<dynamic> get(String path) async {
    final client = HttpClient();
    try {
      final request =
          await client.getUrl(Uri.parse('$_databaseUrl/$path.json'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (body == 'null') return null;
      return jsonDecode(body);
    } finally {
      client.close();
    }
  }

  static Future<void> put(String path, dynamic value) async {
    final client = HttpClient();
    try {
      final request =
          await client.putUrl(Uri.parse('$_databaseUrl/$path.json'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(value));
      await request.close();
    } finally {
      client.close();
    }
  }

  static Future<void> delete(String path) async {
    final client = HttpClient();
    try {
      final request =
          await client.deleteUrl(Uri.parse('$_databaseUrl/$path.json'));
      await request.close();
    } finally {
      client.close();
    }
  }
}
