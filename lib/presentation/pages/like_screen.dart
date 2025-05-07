import 'package:cat_tinder/domain/models/cat.dart';
import 'package:cat_tinder/domain/usecases/swipe_handler.dart';
import 'package:cat_tinder/presentation/widgets/cat_card_like.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  late SwipeHandler swipeHandler;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    swipeHandler = Provider.of<SwipeHandler>(context);
  }

  String selectedBreed = 'Все';

  List<String> getBreeds(List<Cat> cats) {
    final breeds = cats.map((cat) => cat.breed).toSet().toList()..sort();
    return ['Все', ...breeds];
  }

  @override
  Widget build(BuildContext context) {
    final List<Cat> likedCats = swipeHandler.likedCats;
    final breeds = getBreeds(likedCats);

    final filteredCats =
        selectedBreed == 'Все'
            ? likedCats
            : likedCats.where((cat) => (cat.breed) == selectedBreed).toList();

    if (likedCats.isEmpty) {
      return const Center(
        child: Text('Вы ещё не лайкнули ни одного котика 😿'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Понравившиеся котики')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedBreed,
              items:
                  breeds
                      .map(
                        (breed) =>
                            DropdownMenuItem(value: breed, child: Text(breed)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBreed = value!;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child:
                  filteredCats.isEmpty
                      ? const Center(
                        child: Text('Нет котиков по выбранной породе 😿'),
                      )
                      : GridView.builder(
                        itemCount: filteredCats.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (context, index) {
                          final cat = filteredCats[index];
                          return CatCardLike(
                            cat: cat,
                            onDelete:
                                () => {
                                  filteredCats.length > 1
                                      ? swipeHandler.removeLikedCat(cat)
                                      : {
                                        swipeHandler.removeLikedCat(cat),
                                        selectedBreed = 'Все',
                                      },
                                },
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
