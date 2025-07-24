import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'analyze/analyze_screen.dart';
import 'grenate_exam/generate_exam_screen.dart';
import 'exam_preview/exam_preview_screen.dart';
import 'saved_exam/saved_exams_screen.dart';
import 'history_analyzed/history_analyzed_screen.dart';

class DemoScreens extends StatelessWidget {
  const DemoScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    
    if(authState is! AuthLoggedInState){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
      return Scaffold(
        appBar: AppBar(
        title: const Text('All Exam Screens'),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 24),

            // Screen List
            // _buildScreenCard(
            //   context,
            //   'AnalyzeScreen',
            //   'Phân tích câu hỏi từ file',
            //   Icons.analytics,
            //   Colors.blue,
            //   () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const AnalyzeScreen(
            //         extractedContent: 'Đây là nội dung câu hỏi mẫu được trích xuất từ file. Câu hỏi này thuộc về chương 2 của lớp 11, dạng trắc nghiệm với độ khó trung bình.',
            //       filePath: '/path/to/sample/file.pdf',
            //       key: ValueKey('analyze_demo'),
            //       ),
            //     ),
            //   ),
            // ),

            _buildScreenCard(
              context,
              'GenerateExamScreen',
              'Create Exam',
              Icons.auto_awesome,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenerateExamScreen(),
                ),
              ),
            ),

            // _buildScreenCard(
            //   context,
            //   'ExamPreviewScreen',
            //   'Xem trước đề thi',
            //   Icons.preview,
            //   Colors.blue,
            //   () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const ExamPreviewScreen(),
            //     ),
            //   ),
            // ),

            _buildScreenCard(
              context,
              'SavedExamsScreen',
              'View Saved Exams',
              Icons.folder,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedExamsScreen(),
                ),
              ),
            ),

            // _buildScreenCard(
            //   context,
            //   'HistoryAnalyzedScreen',
            //   'Lịch sử phân tích',
            //   Icons.history,
            //   Colors.orange,
            //   () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const HistoryAnalyzedScreen(),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 32),

      
          ],
        ),
      ),
    );
  }

  Widget _buildScreenCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateThroughAllScreens(BuildContext context) async {
    // Navigate through all screens in sequence
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalyzeScreen(
          extractedContent: 'Demo content for analyze screen',
        ),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenerateExamScreen(),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExamPreviewScreen(),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedExamsScreen(),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryAnalyzedScreen(),
      ),
    );
  }
} 