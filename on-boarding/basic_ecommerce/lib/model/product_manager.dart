import 'product.dart';

class ProductManager {
  final List<Product> _products = [];
  ProductManager() {
    _products.addAll(
      List.generate(
        10,
        (index) => Product(
          id: index, // Unique IDs
          title: 'Derby Leather Shoes',
          category: 'Men’s shoe',
          price: 120.0,
          rating: 4.0,
          imageUrl: 'images/image.jpg',
          description:
              'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
          sizes: [39, 40, 41, 42, 43, 44],
        ),
      ),
    );
  }

  List<Product> get products => List.unmodifiable(_products);
}
