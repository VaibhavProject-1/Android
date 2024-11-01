import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'dart:io';

class ProductListScreen extends StatefulWidget {
  final Product? product;

  const ProductListScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _category;
  late double _price, _rating;
  late int _stock;
  final List<String> _images = [];
  final Map<String, List<String>> _variants = {};
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product!.name;
      _description = widget.product!.description;
      _price = widget.product!.price;
      _category = widget.product!.category;
      _stock = widget.product!.stock;
      _rating = widget.product!.rating;
      _images.addAll(widget.product!.images);
      _variants.addAll(widget.product!.variants);
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      _category = '';
      _stock = 0;
      _rating = 0.0;
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
        _images.add(downloadUrl); // Store the image URL in the product data
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        description: _description,
        price: _price,
        images: _images,
        variants: _variants,
        category: _category,
        stock: _stock,
        rating: _rating,
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
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _stock.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                onSaved: (value) => _stock = int.parse(value!),
              ),
              TextFormField(
                initialValue: _rating.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rating'),
                onSaved: (value) => _rating = double.parse(value!),
              ),
              const SizedBox(height: 10),
              const Text('Images'),
              Wrap(
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
                        onPressed: () => _removeImage(entry.key),
                      ),
                    )
                  ],
                ))
                    .toList(),
              ),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Add Image'),
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