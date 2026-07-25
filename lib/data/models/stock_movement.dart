class StockMovement {
  const StockMovement({
    required this.id,
    required this.type,
    required this.qty,
    this.note,
    required this.createdAt,
  });

  final int id;
  final String type;
  final int qty;
  final String? note;
  final DateTime createdAt;

  factory StockMovement.fromMap(Map<String, Object?> map) {
    return StockMovement(
      id: map['id'] as int,
      type: map['type'] as String,
      qty: map['qty'] as int,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
