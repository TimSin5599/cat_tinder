import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cat_tinder/domain/models/cat.dart';

class CatApiService {
  static final String? _baseUrl = dotenv.env['BASE_URL'];
  static final String? _apiKey = dotenv.env['API_URL'];

  Future<List<Cat>> fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?has_breeds=1&limit=5'),
        headers: {'x-api-key': _apiKey!},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((json) => Cat.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Ошибка загрузки данных');
        }
      } else {
        throw Exception('Ошибка загрузки данных');
      }
    } catch (e) {
      debugPrint("Ошибка: $e");
      return [];
    }
  }
}
