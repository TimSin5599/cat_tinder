import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/cat.dart';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';
  static const String _apiKey =
      'live_zUujdxmiWf0KubbtJCN6jeHQ4pKoDMt8BHiZd8RnJTzwRDWpHt9pgzScqEolrB11';

  static Future<Cat?> fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?has_breeds=1&limit=1'),
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return Cat.fromJson(data[0]);
        } else {
          throw Exception('Ошибка загрузки данных');
        }
      } else {
        throw Exception('Ошибка загрузки данных');
      }
    } catch (e) {
      debugPrint("Ошибка: $e");
      return null;
    }
  }
}
