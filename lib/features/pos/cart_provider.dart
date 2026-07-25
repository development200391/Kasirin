import 'package:flutter/foundation.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int _discount = 0;
  int get discount => _discount;

  int get subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);
  int get total {
    final result = subtotal - _discount;
    return result < 0 ? 0 : result;
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.qty);
  bool get isEmpty => _items.isEmpty;

  int qtyOf(Product product) {
    final item = _items.where((item) => item.product.id == product.id).firstOrNull;
    return item?.qty ?? 0;
  }

  bool addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    final currentQty = index >= 0 ? _items[index].qty : 0;

    if (currentQty >= product.stockQty) return false;

    if (index >= 0) {
      _items[index].qty++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    return true;
  }

  void decrementQty(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;

    if (_items[index].qty <= 1) {
      _items.removeAt(index);
    } else {
      _items[index].qty--;
    }
    notifyListeners();
  }

  void setDiscount(int amount) {
    _discount = amount < 0 ? 0 : amount;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _discount = 0;
    notifyListeners();
  }
}
