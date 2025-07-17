
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_Event.dart';
import 'package:phygen/features/Exam/bloc/upload_State.dart';
import 'package:phygen/features/Exam/presentation/widgets/image_preview.dart';
import 'package:phygen/features/Exam/domain/entities/question.dart';

class AnalysisResultScreen extends StatefulWidget {
  final File selectedFile;
  
  const AnalysisResultScreen({
    Key? key,
    required this.selectedFile,
  }) : super(key: key);

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  List<Question>? _questions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnalysis();
    });
  }

  void _startAnalysis() {
    context.read<UploadBloc>().add(UploadFileEvent(filePath: widget.selectedFile));
  }

  void _handleClear() {
    Navigator.pop(context);
  }

  void _handleRetry() {
    _startAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is UploadSuccessState) {
          setState(() {
            _questions = state.fileUpload.data;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Scanning completed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is UploadErrorState) {
          setState(() {
            _questions = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Analyzing Result',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Hiển thị ảnh đã chọn
              // Container(
              //   width: double.infinity,
              //   height: 200,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey.shade300),
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(12),
              //     child: Image.file(
              //       widget.selectedFile,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              if (_isLoading)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Scanning your file...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_questions != null && !_isLoading)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListView.separated(
                      itemCount: _questions!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final q = _questions![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Question ${index + 1}: ${q.question}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('A. ${q.a}'),
                              Text('B. ${q.b}'),
                              Text('C. ${q.c}'),
                              Text('D. ${q.d}'),
                              if (q.answer != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Correct Answer: ${q.answer}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Chip(
                                      label: Text('Difficulty: ${q.difficulty}', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.blue.shade400,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text('Chapter: ${q.chapter} - ${q.chapterName}', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.purple.shade400,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text('Topic: ${q.topic} - ${q.topicName}', style: TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.orange.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (_questions == null && !_isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Something went wrong!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _handleRetry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleClear,
                      icon: const Icon(Icons.clear),
                      label: const Text('Remove'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_questions != null && !_isLoading)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(''),
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_new_folder),
                        label: const Text('Create Exam'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyCircleNavbar(
          selectedIndex: 1,
          onItemSelected: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/');
            } else if (index == 2) {
              // Thay bằng route profile nếu có
              // Navigator.pushReplacementNamed(context, '/profile');
            }
          },
        ),
      ),
    );
  }
} 
