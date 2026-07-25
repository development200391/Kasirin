import 'package:flutter/foundation.dart';

import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/product_repository.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider({
    ProductRepository? productRepository,
    CategoryRepository? categoryRepository,
  })  : _productRepository = productRepository ?? ProductRepository(),
        _categoryRepository = categoryRepository ?? CategoryRepository() {
    load();
  }

  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  List<ProductCategory> _categories = [];
  List<ProductCategory> get categories => _categories;

  List<Product> _products = [];
  List<Product> get products => _products;

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  String _query = '';
  String get query => _query;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _categoryRepository.getAll();
    await _loadProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    _products = await _productRepository.search(
      categoryId: _selectedCategoryId,
      query: _query,
    );
  }

  Future<void> setCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;
    await _loadProducts();
    notifyListeners();
  }

  Future<void> setQuery(String query) async {
    _query = query;
    await _loadProducts();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _categoryRepository.add(name);
    _categories = await _categoryRepository.getAll();
    notifyListeners();
  }

  Future<void> renameCategory(int id, String name) async {
    await _categoryRepository.update(id, name);
    _categories = await _categoryRepository.getAll();
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    await _categoryRepository.delete(id);
    if (_selectedCategoryId == id) {
      _selectedCategoryId = null;
    }
    _categories = await _categoryRepository.getAll();
    await _loadProducts();
    notifyListeners();
  }

  Future<void> saveProduct(Product product) async {
    if (product.id == null) {
      await _productRepository.add(product);
    } else {
      await _productRepository.update(product);
    }
    await _loadProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    await _productRepository.delete(id);
    await _loadProducts();
    notifyListeners();
  }
}
