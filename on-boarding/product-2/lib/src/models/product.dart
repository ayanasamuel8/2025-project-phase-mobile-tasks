class Product {
  final String _name;
  final double _price;
  final String _description;
  static int _idCounter = 0;
  final int _id;

  Product({required String name, required double price, String? description})
    : _id = _idCounter++,
      _name = name.trim(),
      _price = price,
      _description = description ?? '' {
    if (price <= 0) throw ArgumentError('Price must be positive');
    if (name.trim().isEmpty) throw ArgumentError('Name cannot be empty');
  }

  Product._withId({
    required int id,
    required String name,
    required double price,
    String? description,
  }) : _id = id,
       _name = name,
       _price = price,
       _description = description ?? '' {
    if (price <= 0) throw ArgumentError('Price must be positive');
    if (name.trim().isEmpty) throw ArgumentError('Name cannot be empty');

    if (id >= _idCounter) {
      _idCounter = id + 1;
    }
  }

  String get name => _name;
  double get price => _price;
  String get description => _description;
  int get id => _id;

  @override
  String toString() {
    return 'Product{id: $_id, name: $_name, price: $_price, description: $_description}';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('name') ||
        !json.containsKey('price')) {
      throw FormatException('Missing required Product fields');
    }
    return Product._withId(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'price': _price,
      'description': _description,
    };
  }
}
