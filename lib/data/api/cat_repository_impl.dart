import 'package:cat_tinder/data/api/cat_api_service.dart';
import 'package:cat_tinder/domain/models/cat.dart';
import 'package:cat_tinder/domain/usecases/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;

  CatRepositoryImpl(this.apiService);

  @override
  Future<List<Cat>> fetchRandomCats() async {
    return apiService.fetchRandomCat();
  }
}
