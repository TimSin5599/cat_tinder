import 'package:cat_tinder/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/services/api_service.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../models/cat.dart';
import '../widgets/cat_card.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  SwipeScreenState createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();
  final List<Cat> _catCards = [];
  final List<Cat> _catWaitCards = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    _loadNewCat(_catCards);
    _loadNewCat(_catCards);
    _loadNewCat(_catWaitCards);
  }

  Future<void> _loadNewCat(List<Cat> array) async {
    List<Cat> newCats = [];
    for (int i = 0; i < 5; ++i) {
      final cat = await CatApiService.fetchRandomCat();
      debugPrint(
        'The card\n name-${cat?.name}, ${cat?.breed}, ${cat?.description}',
      );
      if (cat != null) {
        newCats.add(cat);
      }
    }

    setState(() {
      array.addAll(newCats);
    });
  }

  void updateList(int index) {
    setState(() {
      _catCards.replaceRange(
        index,
        index + _catWaitCards.length,
        _catWaitCards,
      );
      debugPrint('The catwaitcards under- ${_catWaitCards.length}');
      _catWaitCards.clear();
      _loadNewCat(_catWaitCards);
      debugPrint('The catwaitcards after- ${_catWaitCards.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Koto tinder')),
      body:
          _catCards.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _counter.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CardSwiper(
                        controller: _controller,
                        cardsCount: _catCards.length,
                        onSwipe: _onSwipe,
                        onUndo: _onUndo,
                        numberOfCardsDisplayed: 2,
                        backCardOffset: const Offset(0, 0),
                        // padding: const EdgeInsets.all(24.0),
                        cardBuilder: (context, index, h, v) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CatDetailScreen(
                                        cat: _catCards[index],
                                      ),
                                ),
                              );
                            },
                            child: CatCard(
                              cat: _catCards[index],
                              onLike: () {
                                debugPrint("Liked ${_catCards[index].name}");
                                _controller.swipe(CardSwiperDirection.right);
                              },
                              onDislike: () {
                                debugPrint("Disliked ${_catCards[index].name}");
                                _controller.swipe(CardSwiperDirection.left);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (currentIndex == _catCards.length / 2 ||
        currentIndex == _catCards.length) {
      updateList(currentIndex! - 5);
    }

    if (direction == CardSwiperDirection.right) {
      setState(() {
        _counter++;
      });
    }

    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top\n The current size - ${_catCards.length}',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint('The card $currentIndex was undod from the ${direction.name}');
    return true;
  }
}
