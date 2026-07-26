import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/category.dart';
import '../../l10n/gen/app_localizations.dart';
import 'products_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  Future<void> _showCategoryDialog(BuildContext context, {ProductCategory? category}) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: category?.name ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? l10n.categoryNewTitle : l10n.categoryEditTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.categoryNameLabel),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || !context.mounted) return;

    final provider = context.read<ProductsProvider>();
    if (category == null) {
      await provider.addCategory(name);
    } else {
      await provider.renameCategory(category.id, name);
    }
  }

  Future<void> _confirmDelete(BuildContext context, ProductCategory category) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoryDeleteTitle),
        content: Text(l10n.categoryDeleteConfirm(category.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ProductsProvider>().deleteCategory(category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = context.watch<ProductsProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      body: categories.isEmpty
          ? Center(child: Text(l10n.categoriesEmpty, style: const TextStyle(color: AppColors.textSecondary)))
          : ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showCategoryDialog(context, category: category),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                        onPressed: () => _confirmDelete(context, category),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.categoryAdd),
      ),
    );
  }
}
