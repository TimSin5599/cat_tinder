import 'package:cat_tinder/domain/usecases/swipe_handler.dart';
import 'package:cat_tinder/presentation/pages/like_screen.dart';
import 'package:cat_tinder/presentation/pages/navbar.dart';
import 'package:cat_tinder/presentation/pages/swipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SwipeHandler(),
      builder: (context, child) {
        final pages = [SwipeScreen(), LikeScreen()];

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: pages),
          bottomNavigationBar: NavBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
