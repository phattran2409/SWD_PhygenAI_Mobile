import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadArea extends StatelessWidget {
  final Function(File) onFileSelected;

  const UploadArea({
    Key? key,
    required this.onFileSelected,
  }) : super(key: key);

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          onFileSelected(File(file.path!));
        }
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      onFileSelected(File(photo.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Text(
            'UPLOAD YOUR FILE',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Text(
            'Please upload your file to continue to scanning.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 24),
        DottedBorder(
          color: Colors.grey,
          strokeWidth: 2,
          dashPattern: [6, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickFile,
                  child: const Text(
                    'Tap to upload file or photo',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'PNG, JPG or PDF (max. 800x400px)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openCamera,
                    child: const Text('Open camera'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 