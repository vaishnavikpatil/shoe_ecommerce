class Product {
  final String productId;
  final String name;
  final String description;
  final String brandname;
  final double price;
  final List<String> images;
  final List<String> sizes;
  final List<String> color;
  final String category;
  final int stock;
  final double ratings;
  final int discount;
  final bool isFeatured;
  final bool isActive;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.brandname,
    required this.price,
    required this.images,
    required this.sizes,
    required this.color,
    required this.category,
    required this.stock,
    required this.ratings,
    required this.discount,
    required this.isFeatured,
    required this.isActive,
  });

factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    productId: json['_id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    brandname: json['brandname'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    images: (json['images'] != null)
        ? List<String>.from(json['images'])
        : [],
    sizes: (json['sizes'] != null)
        ? List<String>.from(json['sizes'])
        : [],
    color: (json['color'] != null)
        ? List<String>.from(json['color'])
        : [],
    category: json['category'] ?? '',
    stock: json['stock'] ?? 0,
    ratings: (json['ratings'] ?? 0).toDouble(),
    discount: json['discount'] ?? 0,
    isFeatured: json['isFeatured'] ?? false,
    isActive: json['isActive'] ?? true,
  );
}
}
