import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_response_model.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_bloc.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_event.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_saved_state.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_saved_remote_data_source.dart';
import 'package:phygen/core/services/token_storage_service.dart';

class SavedExamsScreen extends StatefulWidget {
  const SavedExamsScreen({Key? key}) : super(key: key);

  @override
  State<SavedExamsScreen> createState() => _SavedExamsScreenState();
}

class _SavedExamsScreenState extends State<SavedExamsScreen> {
  @override
  void initState() {
    super.initState();
    // Gửi event fetch dữ liệu khi vào màn hình
    Future.microtask(() => context.read<ExamSavedBloc>().add(FetchExamSavedEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Saved Exams'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ExamSavedBloc, ExamSavedState>(
        builder: (context, state) {
          if (state is ExamSavedLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamSavedErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<ExamSavedBloc>().add(RetryFetchExamSavedEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (state is ExamSavedSuccessState) {
            if (state.examSets.isEmpty) {
              return _buildEmptyState();
            }
            return _buildExamsList(state.examSets);
          }
          // State mặc định
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có đề thi nào được lưu',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Các đề thi bạn tạo sẽ xuất hiện ở đây',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/generate-exam');
            },
            icon: const Icon(Icons.add),
            label: const Text('Tạo đề thi mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamsList(List<ExamSetModel> savedExams) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedExams.length,
      itemBuilder: (context, index) {
        final exam = savedExams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: InkWell(
            onTap: () => _viewExam(exam),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and actions
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exam.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) => _handleMenuAction(value, exam),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility, size: 20),
                                SizedBox(width: 8),
                                Text('View'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'export',
                            child: Row(
                              children: [
                                Icon(Icons.file_present, size: 20),
                                SizedBox(width: 8),
                                Text('Export to Word'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (exam.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      exam.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Exam info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip('Class', '11', Colors.blue),
                      _buildInfoChip('Status', exam.status, Colors.green),
                      
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Date info
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Tạo: ${_formatDate(exam.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        value.isEmpty ? label : '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _viewExam(ExamSetModel exam) {
    Navigator.pushNamed(
      context,
      '/view-exam',
      arguments: {
        'examId': exam.id,
      },
    );
  }

  void _exportToWord(ExamSetModel exam) async {
    try {
      final token = await TokenStorageService().getToken();
      await ExamSavedRemoteDataSource().downloadExamWordFile(
        examSetId: exam.id,
        token: token ?? '',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved ${exam.title} to Downloads Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  void _handleMenuAction(String action, ExamSetModel exam) {
    switch (action) {
      case 'view':
        _viewExam(exam);
        break;
      case 'export':
        _exportToWord(exam);
        break;
      case 'delete':
        _deleteExam(exam);
        break;
    }
  }

  void _deleteExam(ExamSetModel exam) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exam'),
        content: Text('Are you sure you want to delete "${exam.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ExamSavedBloc>().add(DeleteExamSetEvent(exam.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 