import 'dart:convert';

import 'package:cat_tinder/data/api/cat_api_service.dart';
import 'package:cat_tinder/data/api/cat_repository_impl.dart';
import 'package:cat_tinder/domain/models/cat.dart';
import 'package:cat_tinder/domain/usecases/check_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwipeHandler with ChangeNotifier {
  final List<Cat> _catCards = [];
  final List<Cat> _catWaitCards = [];
  final CatRepositoryImpl _catRepository = CatRepositoryImpl(CatApiService());
  bool _hasInternet = true;
  int _counter = 0;

  SwipeHandler() {
    initialize();
  }

  int get counter => _counter;
  List<Cat> get catCards => _catCards;
  bool get hasInternetVar => _hasInternet;

  Future<void> loadNewCat(List<Cat> array) async {
    _hasInternet = await updateInternetStatus();
    List<Cat> newCats = await _catRepository.fetchRandomCats();
    notifyListeners();
    array.addAll(newCats);
    notifyListeners();
  }

  void initialize() async {
    _catCards.clear();
    List<Cat> likedCats = await getLikedCats();
    _counter = likedCats.length;
    await loadNewCat(_catCards);
    await loadNewCat(_catCards);
    await loadNewCat(_catWaitCards);
  }

  void updateList(int index) async {
    _catCards.replaceRange(index, index + 5, _catWaitCards);
    _catWaitCards.clear();
    await loadNewCat(_catWaitCards);
  }

  Future<bool> updateInternetStatus() async {
    final bool result = await hasInternet();
    return result;
  }

  void handleSwipe(CardSwiperDirection direction) async {
    _hasInternet = await updateInternetStatus();
    notifyListeners();
  }

  bool onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (previousIndex == 4) {
      updateList(0);
    } else if (currentIndex == 0) {
      updateList(5);
    }

    if (direction == CardSwiperDirection.right) {
      Cat cat = _catCards[previousIndex];
      cat.likedAt = DateTime.now();
      addLikedCat(cat);
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

  Future<void> removeLikedCat(Cat cat) async {
    final likedCats = await getLikedCats();
    likedCats.removeWhere((c) => c.id == cat.id);
    await saveLikedCats(likedCats);
  }

  Future<void> addLikedCat(Cat cat) async {
    final List<Cat> likedCats = await getLikedCats();

    if (likedCats.any((c) => c.id == cat.id)) return;

    cat.likedAt = DateTime.now();
    likedCats.add(cat);
    saveLikedCats(likedCats);
  }

  Future<void> saveLikedCats(List<Cat> cats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cats.map((cat) => cat.toJson()).toList());
    await prefs.setString('liked_cats', jsonString);
    _counter = cats.length;
    notifyListeners();
  }

  Future<List<Cat>> getLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('liked_cats');

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((json) => Cat.fromLocalJson(json)).toList();
  }
}
