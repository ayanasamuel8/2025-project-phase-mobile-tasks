class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final String details;
  final List<int> sizes;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.rating = 0.0,
    required this.imageUrl,
    required this.details,
    required this.sizes,
  });
}
