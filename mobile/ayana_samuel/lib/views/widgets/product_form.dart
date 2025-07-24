import 'dart:io';

import 'package:basic_ecommerce/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:basic_ecommerce/model/product.dart';
import 'package:basic_ecommerce/views/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final String submitButtonText;
  final Function(Product product) onSubmit;

  const ProductForm({
    super.key,
    this.initialProduct,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProduct?.title ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.initialProduct?.category ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialProduct?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialProduct?.description ?? '',
    );
    if (widget.initialProduct?.imageUrl != null &&
        !widget.initialProduct!.imageUrl.startsWith('images/')) {
      _imageFile = File(widget.initialProduct!.imageUrl);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _saveImagePermanently(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy(path.join(appDir.path, fileName));
    return savedImage.path;
  }

  Future<void> _submitForm() async {
    if (widget.initialProduct == null && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? imagePath = widget.initialProduct?.imageUrl ?? '';
    if (_imageFile != null &&
        _imageFile!.path != widget.initialProduct?.imageUrl) {
      imagePath = await _saveImagePermanently(_imageFile!);
    }

    final productToSubmit = Product(
      id: widget.initialProduct?.id ?? 0,
      title: _nameController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      imageUrl: imagePath ?? '',
      sizes: widget.initialProduct?.sizes ?? [],
    );
    widget.onSubmit(productToSubmit);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _pickImage,
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/image_icon.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: CustomColor.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // ... (the rest of your form TextFields)
            buildTextField(
              'name',
              Colors.grey[300],
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'category',
              Colors.grey[300],
              controller: _categoryController,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'price',
              Colors.grey[300],
              controller: _priceController,
            ),
            const SizedBox(height: 20),
            buildTextField(
              'description',
              Colors.grey[300],
              controller: _descriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            Theme(
              data: Theme.of(context).copyWith(useMaterial3: false),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _submitForm();
                            }
                          },
                          child: Text(widget.submitButtonText),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
