import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cat_tinder/domain/usecases/swipe_handler.dart';
import 'package:cat_tinder/presentation/widgets/cat_card.dart';
import 'package:cat_tinder/presentation/pages/details_screen.dart';
import 'package:provider/provider.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  SwipeScreenState createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SwipeHandler swipeHandler = Provider.of<SwipeHandler>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Кототиндер')),
      body: ListenableBuilder(
        listenable: swipeHandler,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              swipeHandler.catCards.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            swipeHandler.counter.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CardSwiper(
                            controller: _controller,
                            cardsCount: swipeHandler.catCards.length,
                            onSwipe: swipeHandler.onSwipe,
                            onUndo: swipeHandler.onUndo,
                            numberOfCardsDisplayed: 2,
                            backCardOffset: const Offset(0, 0),
                            cardBuilder: (context, index, h, v) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CatDetailScreen(
                                            cat: swipeHandler.catCards[index],
                                          ),
                                    ),
                                  );
                                },
                                child: CatCard(
                                  cat: swipeHandler.catCards[index],
                                  onLike: () {
                                    _controller.swipe(
                                      CardSwiperDirection.right,
                                    );
                                  },
                                  onDislike: () {
                                    _controller.swipe(CardSwiperDirection.left);
                                  },
                                ),
                              );
                            },
                            allowedSwipeDirection:
                                AllowedSwipeDirection.symmetric(
                                  horizontal: true,
                                  vertical: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
              if (!swipeHandler.hasInternetVar)
                Center(
                  child: AlertDialog(
                    title: const Text("Нет интернета"),
                    content: const Text("Проверьте подключение к сети."),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          swipeHandler.initialize();
                          setState(() {});
                        },
                        child: const Text("Повторить"),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// FutureBuilder(
//     future: hasInternet(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(
//             child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return const Center(child: Text('Ошибка при проверке интернета'));
//       } else if (!(snapshot.data ?? false)) {
//         return NoInternetScreen(
//                 onRetry: () async {
//                   widget.swipeHandler.initialize();
//                 },
//               );
//       } else {
//
//       }
//     }
// )
