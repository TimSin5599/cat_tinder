class Cat {
  final String id;
  final String imageUrl;
  final String name;
  final String breed;
  final String description;
  final String temperament;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.description,
    required this.temperament,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    var breedData = json['breeds'].isNotEmpty ? json['breeds'][0] : null;

    return Cat(
      id: json['id'],
      imageUrl: json['url'],
      name: breedData != null ? breedData['name'] : 'Unknown',
      breed: breedData != null ? breedData['name'] : 'Unknown breed',
      description:
          breedData != null
              ? breedData['description']
              : 'No description available',
      temperament: breedData != null ? breedData['temperament'] : 'Unknown',
    );
  }
}
