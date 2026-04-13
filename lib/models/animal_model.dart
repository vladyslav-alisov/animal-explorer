class Animal {
  final String id;
  final String name;
  final String category;
  final String habitat;
  final String diet;
  final String lifespan;
  final String funFact;
  final String imagePath;
  bool isFavorite;

  Animal({
    required this.id,
    required this.name,
    required this.category,
    required this.habitat,
    required this.diet,
    required this.lifespan,
    required this.funFact,
    required this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'habitat': habitat,
        'diet': diet,
        'lifespan': lifespan,
        'funFact': funFact,
        'imagePath': imagePath,
        'isFavorite': isFavorite,
      };

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        habitat: json['habitat'],
        diet: json['diet'],
        lifespan: json['lifespan'],
        funFact: json['funFact'],
        imagePath: json['imagePath'],
        isFavorite: json['isFavorite'] ?? false,
      );
}
