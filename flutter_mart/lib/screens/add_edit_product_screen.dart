import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // For input formatters
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'dart:io';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final List<String> _images = [];
  final Map<String, List<String>> _variants = {};
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _categoryController.text = widget.product!.category;
      _stockController.text = widget.product!.stock.toString();
      _ratingController.text = widget.product!.rating.toString();
      _images.addAll(widget.product!.images);
      _variants.addAll(widget.product!.variants);
    }
  }

  Future<void> _pickImage() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final File file = File(imageFile.path);
      final String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final TaskSnapshot uploadTask = await _storage.ref(fileName).putFile(file);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _images.add(downloadUrl);
      });
    }
  }

  void _addVariant() {
    TextEditingController variantTypeController = TextEditingController();
    TextEditingController variantValueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Variant"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: variantTypeController,
                decoration: const InputDecoration(labelText: 'Variant Type (e.g., Size, Color)'),
              ),
              TextField(
                controller: variantValueController,
                decoration: const InputDecoration(labelText: 'Variant Values (comma separated)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final String variantType = variantTypeController.text.trim();
                final List<String> variantValues = variantValueController.text.split(',').map((e) => e.trim()).toList();

                if (variantType.isNotEmpty && variantValues.isNotEmpty) {
                  setState(() {
                    _variants[variantType] = variantValues;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        images: _images,
        variants: _variants,
        category: _categoryController.text,
        stock: int.tryParse(_stockController.text) ?? 0,
        rating: double.tryParse(_ratingController.text) ?? 0.0,
      );

      if (widget.product == null) {
        await productProvider.addProduct(product);
      } else {
        await productProvider.updateProduct(product);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., iPhone 13',
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Latest model with improved battery',
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                decoration: const InputDecoration(
                  hintText: 'e.g., 999.99',
                  labelText: 'Price',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Electronics',
                  labelText: 'Category',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'e.g., 50',
                  labelText: 'Stock Quantity',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stock quantity is required';
                  } else if (int.tryParse(value) == null) {
                    return 'Enter a valid stock quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                decoration: const InputDecoration(
                  hintText: 'e.g., 4.5',
                  labelText: 'Rating',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Rating is required';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid rating';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Images'),
              Wrap(
                children: _images
                    .map((image) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(image, width: 80, height: 80),
                ))
                    .toList(),
              ),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Add Image URL'),
              ),
              const SizedBox(height: 10),
              const Text('Variants'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _variants.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text('${entry.key}: ${entry.value.join(', ')}'),
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: _addVariant,
                child: const Text('Add Variant Option'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProduct, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}