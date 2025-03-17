import 'package:flutter/material.dart';
import '../models/cat.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  cat.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Имя: ${cat.name}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Порода: ${cat.breed}", style: const TextStyle(fontSize: 18)),
            Text(
              "Описание: ${cat.description}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Назад"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
