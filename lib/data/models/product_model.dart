class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  String get formattedPrice => '₹${(price * 83).toStringAsFixed(0)}';
  String get shortTitle => title.length > 40 ? '${title.substring(0, 40)}...' : title;
  String get categoryLabel => category[0].toUpperCase() + category.substring(1);
}

class Rating {
  final double rate;
  final int count;

  const Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}