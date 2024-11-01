import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'dart:io';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({Key? key}) : super(key: key);

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String _name = '';
  String _description = '';
  String _category = '';
  double _price = 0.0;
  double _rating = 0.0;
  int _stock = 0;
  List<String> _images = [];
  List<String> _imagesToRemove = [];
  Map<String, List<String>> _variants = {};

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.loadProducts();
  }

  void _showProductFormDialog({Product? product}) {
    if (product != null) {
      _name = product.name;
      _description = product.description;
      _price = product.price;
      _category = product.category;
      _stock = product.stock;
      _rating = product.rating;
      _images = List.from(product.images);
      _variants = Map.from(product.variants);
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      _category = '';
      _stock = 0;
      _rating = 0.0;
      _images = [];
      _variants = {};
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product == null ? 'Add Product' : 'Edit Product',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          initialValue: _name,
                          label: 'Product Name',
                          onSaved: (value) => _name = value!,
                        ),
                        _buildTextField(
                          initialValue: _description,
                          label: 'Description',
                          onSaved: (value) => _description = value!,
                        ),
                        _buildTextField(
                          initialValue: _price.toString(),
                          label: 'Price',
                          isNumber: true,
                          onSaved: (value) => _price = double.tryParse(value!) ?? 0.0,
                        ),
                        _buildTextField(
                          initialValue: _category,
                          label: 'Category',
                          onSaved: (value) => _category = value!,
                        ),
                        _buildTextField(
                          initialValue: _stock.toString(),
                          label: 'Stock Quantity',
                          isNumber: true,
                          onSaved: (value) => _stock = int.tryParse(value!) ?? 0,
                        ),
                        _buildTextField(
                          initialValue: _rating.toString(),
                          label: 'Rating',
                          isNumber: true,
                          onSaved: (value) => _rating = double.tryParse(value!) ?? 0.0,
                        ),
                        const SizedBox(height: 10),
                        const Text('Images'),
                        _buildImageList(setState),
                        TextButton(
                          onPressed: () => _pickImage(setState),
                          child: const Text('Add Image'),
                        ),
                        const SizedBox(height: 10),
                        const Text('Variants'),
                        _buildVariantList(setState),
                        TextButton(
                          onPressed: () => _addVariant(setState),
                          child: const Text('Add Variant Option'),
                        ),
                        const SizedBox(height: 20),
                        _buildActionButtons(product),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required String label,
    required FormFieldSetter<String> onSaved,
    bool isNumber = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
      validator: (value) => value!.isEmpty ? 'Please enter a $label' : null,
    );
  }

  Widget _buildImageList(StateSetter setState) {
    return Wrap(
      children: _images
          .asMap()
          .entries
          .map((entry) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.network(entry.value, width: 80, height: 80),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                setState(() {
                  _imagesToRemove.add(_images[entry.key]);
                  _images.removeAt(entry.key);
                });
              },
            ),
          ),
        ],
      ))
          .toList(),
    );
  }

  Widget _buildVariantList(StateSetter setState) {
    return Column(
      children: _variants.entries.map((entry) {
        TextEditingController typeController = TextEditingController(text: entry.key);
        TextEditingController valuesController = TextEditingController(text: entry.value.join(', '));

        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Variant Type'),
                onChanged: (value) {
                  setState(() {
                    _variants.remove(entry.key);
                    _variants[value] = entry.value;
                  });
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: valuesController,
                decoration: const InputDecoration(labelText: 'Values (comma-separated)'),
                onChanged: (value) {
                  setState(() {
                    _variants[entry.key] = value.split(',').map((v) => v.trim()).toList();
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _variants.remove(entry.key);
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  void _addVariant(StateSetter setState) {
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
                decoration: const InputDecoration(labelText: 'Variant Values (comma-separated)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  Future<void> _pickImage(StateSetter setState) async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      final String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final TaskSnapshot uploadTask = await _storage.ref(fileName).putFile(File(imageFile.path));
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      setState(() => _images.add(downloadUrl));
    }
  }

  Future<void> _deleteImagesFromFirebase() async {
    for (String imageUrl in _imagesToRemove) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
    _imagesToRemove.clear();
  }

  Future<void> _saveProduct(Product? existingProduct) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      final product = Product(
        id: existingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        description: _description,
        price: _price,
        images: _images,
        variants: _variants,
        category: _category,
        stock: _stock,
        rating: _rating,
      );

      if (existingProduct == null) {
        await productProvider.addProduct(product);
      } else {
        await productProvider.updateProduct(product);
      }

      await _deleteImagesFromFirebase();
      Navigator.pop(context);
    }
  }

  Widget _buildActionButtons(Product? product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => _saveProduct(product),
          child: const Text("Save"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductFormDialog(),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ListTile(
                  leading: product.images.isNotEmpty
                      ? Image.network(product.images.first, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showProductFormDialog(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => productProvider.deleteProduct(product.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}