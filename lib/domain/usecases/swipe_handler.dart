import 'package:cat_tinder/data/api/cat_repository.dart';
import 'package:cat_tinder/domain/models/cat.dart';
import 'package:cat_tinder/domain/usecases/check_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeHandler with ChangeNotifier {
  final List<Cat> _catCards = [];
  final List<Cat> _catWaitCards = [];
  final CatRepository _catRepository = CatRepository();
  final List<Cat> _likedCats = [];
  bool _hasInternet = true;
  int _counter = 0;

  SwipeHandler() {
    initialize();
  }

  int get counter => _counter;
  List<Cat> get catCards => _catCards;
  bool get hasInternetVar => _hasInternet;
  List<Cat> get likedCats => _likedCats;

  Future<void> loadNewCat(List<Cat> array) async {
    List<Cat> newCats = [];
    for (int i = 0; i < 5; ++i) {
      final cat = await _catRepository.fetchRandomCats();
      _hasInternet = await updateInternetStatus();
      notifyListeners();
      if (cat != null) {
        newCats.add(cat);
      }
    }

    array.addAll(newCats);
    notifyListeners();
  }

  void initialize() async {
    _catCards.clear();
    await loadNewCat(_catCards);
    await loadNewCat(_catCards);
    await loadNewCat(_catWaitCards);
  }

  void updateList(int index) {
    _catCards.replaceRange(index, index + _catWaitCards.length, _catWaitCards);
    _catWaitCards.clear();
    loadNewCat(_catWaitCards);
  }

  Future<bool> updateInternetStatus() async {
    final bool result = await hasInternet();
    return result;
  }

  void handleSwipe(CardSwiperDirection direction) async {
    if (direction == CardSwiperDirection.right) {
      _counter++;
    }
    _hasInternet = await updateInternetStatus();
    notifyListeners();
  }

  bool onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (currentIndex == catCards.length / 2 ||
        currentIndex == catCards.length) {
      updateList(currentIndex! - 5);
    }

    if (direction == CardSwiperDirection.right) {
      Cat cat = _catCards[previousIndex];
      cat.likedAt = DateTime.now();
      _likedCats.add(cat);
    }

    handleSwipe(direction);

    return true;
  }

  bool onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undod from the ${direction.name}');
    return true;
  }

  void removeLikedCat(Cat cat) {
    _likedCats.remove(cat);
    notifyListeners();
  }
}
