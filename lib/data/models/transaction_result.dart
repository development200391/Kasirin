class TransactionItemResult {
  const TransactionItemResult({
    required this.productName,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  final String productName;
  final int qty;
  final int price;
  final int subtotal;
}

class TransactionResult {
  const TransactionResult({
    required this.id,
    required this.invoiceNo,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.createdAt,
  });

  final int id;
  final String invoiceNo;
  final List<TransactionItemResult> items;
  final int subtotal;
  final int discount;
  final int totalAmount;
  final int paidAmount;
  final int changeAmount;
  final DateTime createdAt;
}
