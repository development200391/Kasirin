import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/product.dart';
import '../../l10n/gen/app_localizations.dart';
import 'products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _priceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _unitController;

  int? _categoryId;
  String? _imagePath;
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _skuController = TextEditingController(text: product?.sku ?? '');
    _priceController = TextEditingController(text: product != null ? product.price.toString() : '');
    _costPriceController = TextEditingController(text: product != null ? product.costPrice.toString() : '0');
    _stockController = TextEditingController(text: product != null ? product.stockQty.toString() : '0');
    _unitController = TextEditingController(text: product?.unit ?? '');
    _categoryId = product?.categoryId;
    _imagePath = product?.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    if (!mounted) return;
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context).productFormCropTitle,
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.primary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
      ],
    );
    if (cropped == null) return;

    final productsDir = Directory('${(await getApplicationDocumentsDirectory()).path}/product_images');
    if (!await productsDir.exists()) {
      await productsDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final savedFile = await File(cropped.path).copy('${productsDir.path}/$fileName');

    setState(() => _imagePath = savedFile.path);
  }

  Future<void> _addCategoryDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoryNewTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.categoryNameLabel),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.commonAdd),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || !mounted) return;

    final provider = context.read<ProductsProvider>();
    await provider.addCategory(name);
    final newCategory = provider.categories.firstWhere((c) => c.name == name);
    setState(() => _categoryId = newCategory.id);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final product = Product(
      id: widget.product?.id,
      categoryId: _categoryId,
      sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
      name: _nameController.text.trim(),
      price: int.parse(_priceController.text),
      costPrice: int.tryParse(_costPriceController.text) ?? 0,
      stockQty: int.tryParse(_stockController.text) ?? 0,
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      imagePath: _imagePath,
    );

    await context.read<ProductsProvider>().saveProduct(product);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = context.watch<ProductsProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.productFormEditTitle : l10n.productFormAddTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                        )
                      : const Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.productFormName),
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.productFormNameRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _skuController,
              decoration: InputDecoration(labelText: l10n.productFormSku),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: _categoryId,
              decoration: InputDecoration(labelText: l10n.productFormCategory),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.productFormNoCategory)),
                ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addCategoryDialog,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.productFormNewCategory),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.productFormPrice),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.productFormRequired;
                      if (int.tryParse(v) == null) return l10n.productFormMustBeNumber;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _costPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.productFormCostPrice),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.productFormStock),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _unitController,
                    decoration: InputDecoration(labelText: l10n.productFormUnit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : Text(_isEditing ? l10n.productFormSaveChanges : l10n.productsAdd),
            ),
          ],
        ),
      ),
    );
  }
}
