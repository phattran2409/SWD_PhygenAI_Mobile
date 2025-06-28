import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';
import 'package:phygen/features/Home/homePage.dart';
import 'package:phygen/features/Profile/presentation/profilePages.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_Event.dart';
import 'package:phygen/features/Exam/bloc/upload_State.dart';
import 'package:phygen/features/Exam/presentation/widgets/upload_area.dart';
import 'package:phygen/features/Exam/presentation/widgets/image_preview.dart';
import 'package:phygen/features/Exam/presentation/screens/upload/upload_result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
   int _selectedIndex = 1;
  final List<Widget> _pages = [MyHomePage(), UploadScreen(), ProfilePage()];
  void _handleFileSelected(File file) {
    setState(() {
      _selectedFile = file;
    });
    context.read<UploadBloc>().add(FileSelectedEvent(fileName: file));
  }

  void _handleClear() {
    setState(() {
      _selectedFile = null;
    });
    context.read<UploadBloc>().add(RemoveFileEvent());
  }

  void _handleAnalyze() {
    if (_selectedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: BlocProvider.of<UploadBloc>(context),
                child: AnalysisResultScreen(selectedFile: _selectedFile!),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //upload area and image widget
              UploadArea(onFileSelected: _handleFileSelected),
              if (_selectedFile != null)
                ImagePreview(
                  file: _selectedFile!,
                  onClear: _handleClear,
                  onAnalyze: _handleAnalyze,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyCircleNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected:  
          (index) {
            setState(() {
              // Navigate to the selected page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => _pages[index],
                ),
              );
            });
          },
      ),
    );
  }
}
