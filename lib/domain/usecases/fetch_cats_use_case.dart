import 'package:cat_tinder/data/api/cat_repository.dart';
import 'package:cat_tinder/domain/models/cat.dart';

class FetchCatsUseCase {
  final CatRepository _catRepository;

  FetchCatsUseCase(this._catRepository);

  Future<Cat?> fetchRandomCats() async {
    return await _catRepository.fetchRandomCats();
  }
}
