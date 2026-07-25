import 'product.dart';

class CartItem {
  CartItem({required this.product, this.qty = 1});

  final Product product;
  int qty;

  int get subtotal => product.price * qty;
}
