class Product {
  final int? id;
  final int? categoryId;
  final String? categoryName;
  final String? sku;
  final String name;
  final int price;
  final int costPrice;
  final int stockQty;
  final String? unit;
  final String? imagePath;

  const Product({
    this.id,
    this.categoryId,
    this.categoryName,
    this.sku,
    required this.name,
    required this.price,
    this.costPrice = 0,
    this.stockQty = 0,
    this.unit,
    this.imagePath,
  });

  factory Product.fromMap(Map<String, Object?> map) {
    return Product(
      id: map['id'] as int,
      categoryId: map['category_id'] as int?,
      categoryName: map['category_name'] as String?,
      sku: map['sku'] as String?,
      name: map['name'] as String,
      price: map['price'] as int,
      costPrice: map['cost_price'] as int,
      stockQty: map['stock_qty'] as int,
      unit: map['unit'] as String?,
      imagePath: map['image_path'] as String?,
    );
  }

  Product copyWith({
    int? categoryId,
    String? sku,
    String? name,
    int? price,
    int? costPrice,
    int? stockQty,
    String? unit,
    String? imagePath,
  }) {
    return Product(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stockQty: stockQty ?? this.stockQty,
      unit: unit ?? this.unit,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
