import 'package:cat_tinder/domain/models/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> fetchRandomCats();
}
