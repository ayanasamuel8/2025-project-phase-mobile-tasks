class Product {
  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;
  final List<int> sizes;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.rating = 0.0,
    required this.imageUrl,
    required this.description,
    required this.sizes,
  });
}
