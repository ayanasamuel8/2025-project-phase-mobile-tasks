import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/colors.dart';
import 'text_field.dart';

class ProductForm extends StatefulWidget {
  final String? initialProductId;
  final String? initialProductName;
  final String? initialProductDescription;
  final double? initialProductPrice;
  final String? initialProductImageUrl;
  final String submitButtonText;
  final Function onSubmit;

  const ProductForm({
    super.key,
    this.initialProductId,
    this.initialProductName,
    this.initialProductDescription,
    this.initialProductPrice,
    this.initialProductImageUrl,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProductName ?? '',
    );

    _priceController = TextEditingController(
      text: widget.initialProductPrice?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialProductDescription ?? '',
    );
    if (widget.initialProductImageUrl != null &&
        !widget.initialProductImageUrl!.startsWith('images/')) {
      _imageFile = File(widget.initialProductImageUrl!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
    if (widget.initialProductId == null && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? imagePath = widget.initialProductImageUrl ?? '';
    if (_imageFile != null &&
        _imageFile!.path != widget.initialProductImageUrl) {
      imagePath = await _saveImagePermanently(_imageFile!);
    }
    if (widget.submitButtonText == 'Update') {
      widget.onSubmit(
        widget.initialProductId,
        _nameController.text,
        _descriptionController.text,
        double.tryParse(_priceController.text) ?? 0.0,
        imagePath ?? 'image/example',
      );
    } else {
      widget.onSubmit(
        _nameController.text,
        _descriptionController.text,
        double.tryParse(_priceController.text) ?? 0.0,
        imagePath ?? 'image/example',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
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
                            const SizedBox(height: 10),
                            const Text(
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
            Column(
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
