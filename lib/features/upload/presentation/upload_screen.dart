import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedFile = File(photo.path);
      });
    }
  }

  Widget _buildPreview() {
    // For testing purposes
    if (_selectedFile == null) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Image.file(_selectedFile!, height: 160),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFile = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
              child: const Text('Clear File'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement analyze functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Analyze This File'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: Colors.black),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 20.0, top: 10),

              iconSize: 40,
            ),
            tooltip: 'Login Here',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            // onPressed: () {
            //   Navigator.pushNamed();
            // },
            // widget: const Text('Login', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  'Please upload your file to continue to analyzing.',
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
                        child: Text(
                          'Tap to upload photo',
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
                      Row(
                        children: const [
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
              _buildPreview(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyCircleNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 2) {
            // Thay bằng route profile nếu có
            // Navigator.pushReplacementNamed(context, '/profile');
          }
          // index == 1 là upload, không làm gì
        },
      ),
    );
  }
}
