class ProductCategory {
  final int id;
  final String name;

  const ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromMap(Map<String, Object?> map) {
    return ProductCategory(id: map['id'] as int, name: map['name'] as String);
  }
}
