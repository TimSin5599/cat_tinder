import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cat_tinder/domain/models/cat.dart';
import 'package:cat_tinder/domain/usecases/swipe_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  late SwipeHandler swipeHandler;

  final testCat = Cat(
    id: '1',
    imageUrl: 'https://example.com/cat.jpg',
    name: 'Mittens',
    breed: 'Maine Coon',
    description: 'A lovely cat',
    temperament: 'Calm',
    likedAt: DateTime.now(),
  );

  setUp(() {
    swipeHandler = SwipeHandler();
  });

  test('добавляет кота в список понравившихся', () async {
    await swipeHandler.addLikedCat(testCat);
    final likedCats = await swipeHandler.getLikedCats();

    expect(likedCats.length, 1);
    expect(likedCats.first.id, '1');
  });

  test('не добавляет одного и того же кота дважды', () async {
    await swipeHandler.addLikedCat(testCat);
    await swipeHandler.addLikedCat(testCat);
    final likedCats = await swipeHandler.getLikedCats();

    expect(likedCats.length, 1);
  });

  test('удаляет кота из понравившихся', () async {
    await swipeHandler.addLikedCat(testCat);
    await swipeHandler.removeLikedCat(testCat);
    final likedCats = await swipeHandler.getLikedCats();

    expect(likedCats, isEmpty);
  });
}
