import 'package:cat_tinder/data/api/cat_api_service.dart';
import 'package:cat_tinder/domain/models/cat.dart';

class CatRepository {
  Future<Cat?> fetchRandomCats() {
    return CatApiService.fetchRandomCat();
  }
}
