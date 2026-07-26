import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../l10n/gen/app_localizations.dart';
import '../products/products_provider.dart';
import 'cart_provider.dart';
import 'widgets/cart_sheet.dart';

void _openCart(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<CartProvider>(),
      child: const CartSheet(),
    ),
  );
}

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).posTitle)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _SearchField(),
          ),
          const _CategoryFilterChips(),
          const SizedBox(height: 4),
          const Expanded(child: _ProductGrid()),
        ],
      ),
      bottomNavigationBar: const _CartBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => context.read<ProductsProvider>().setQuery(value),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).posSearchHint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _CategoryChip(
            label: AppLocalizations.of(context).commonAll,
            selected: provider.selectedCategoryId == null,
            onTap: () => provider.setCategory(null),
          ),
          for (final category in provider.categories)
            _CategoryChip(
              label: category.name,
              selected: provider.selectedCategoryId == category.id,
              onTap: () => provider.setCategory(category.id),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary),
        backgroundColor: AppColors.background,
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();

    if (productsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productsProvider.products.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).posProductNotFound, style: const TextStyle(color: AppColors.textSecondary)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: productsProvider.products.length,
      itemBuilder: (context, index) => _ProductCard(product: productsProvider.products[index]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qtyInCart = cart.qtyOf(product);
    final outOfStock = product.stockQty <= 0;
    final isLowStock = product.stockQty < 10;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _Thumbnail(product: product)),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isLowStock ? AppColors.danger : AppColors.success),
                    ),
                    child: Text(
                      AppLocalizations.of(context).posStockBadge(product.stockQty),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? AppColors.danger : AppColors.success,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatCurrency(product.price),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: outOfStock
                    ? null
                    : () {
                        if (!cart.addProduct(product)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context).posOutOfStock)),
                          );
                        }
                      },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: outOfStock ? AppColors.textSecondary : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    qtyInCart > 0 ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final path = product.imagePath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        child: path != null
            ? Image.file(File(path), fit: BoxFit.cover, errorBuilder: (_, _, _) => _InitialLabel(name: product.name))
            : _InitialLabel(name: product.name),
      ),
    );
  }
}

class _InitialLabel extends StatelessWidget {
  const _InitialLabel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 28),
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  const _CartBar();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _openCart(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context).posViewOrder, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  Text(
                    formatCurrency(cart.total),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
