import 'package:flutter/material.dart';

class SavedExamsScreen extends StatefulWidget {
  const SavedExamsScreen({Key? key}) : super(key: key);

  @override
  State<SavedExamsScreen> createState() => _SavedExamsScreenState();
}

class _SavedExamsScreenState extends State<SavedExamsScreen> {
  List<Map<String, dynamic>> savedExams = [];

  @override
  void initState() {
    super.initState();
    _loadSavedExams();
  }

  void _loadSavedExams() {
    // Mock data - replace with actual data loading
    savedExams = [
      {
        'id': '1',
        'title': 'Đề thi Toán Lớp 11 - Chương 2',
        'grade': 'Lớp 11',
        'chapter': 'Chương 2',
        'type': 'Trắc nghiệm',
        'difficulty': 'Trung bình',
        'questionCount': 20,
        'createdAt': '2024-01-15',
        'lastModified': '2024-01-15',
      },
      {
        'id': '2',
        'title': 'Đề thi Vật lý Lớp 12 - Chương 1',
        'grade': 'Lớp 12',
        'chapter': 'Chương 1',
        'type': 'Kết hợp',
        'difficulty': 'Khó',
        'questionCount': 25,
        'createdAt': '2024-01-14',
        'lastModified': '2024-01-14',
      },
      {
        'id': '3',
        'title': 'Đề thi Hóa học Lớp 10 - Chương 3',
        'grade': 'Lớp 10',
        'chapter': 'Chương 3',
        'type': 'Tự luận',
        'difficulty': 'Dễ',
        'questionCount': 15,
        'createdAt': '2024-01-13',
        'lastModified': '2024-01-13',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đề thi đã lưu'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: savedExams.isEmpty
          ? _buildEmptyState()
          : _buildExamsList(),
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

  Widget _buildExamsList() {
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
                          exam['title'],
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
                                Text('Xem'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Chỉnh sửa'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'export',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf, size: 20),
                                SizedBox(width: 8),
                                Text('Xuất PDF'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share, size: 20),
                                SizedBox(width: 8),
                                Text('Chia sẻ'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Xóa', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Exam info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip('Lớp', exam['grade'], Colors.blue),
                      _buildInfoChip('Chương', exam['chapter'], Colors.green),
                      _buildInfoChip('Dạng', exam['type'], Colors.orange),
                      _buildInfoChip('Độ khó', exam['difficulty'], _getDifficultyColor(exam['difficulty'])),
                      _buildInfoChip('${exam['questionCount']} câu', '', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Date info
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Tạo: ${exam['createdAt']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.update, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Cập nhật: ${exam['lastModified']}',
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Dễ':
        return Colors.green;
      case 'Trung bình':
        return Colors.orange;
      case 'Khó':
        return Colors.red;
      case 'Rất khó':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _viewExam(Map<String, dynamic> exam) {
    Navigator.pushNamed(
      context,
      '/exam-preview',
      arguments: {
        'examId': exam['id'],
        'isReadOnly': true,
      },
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> exam) {
    switch (action) {
      case 'view':
        _viewExam(exam);
        break;
      case 'edit':
        Navigator.pushNamed(
          context,
          '/exam-preview',
          arguments: {
            'examId': exam['id'],
            'isReadOnly': false,
          },
        );
        break;
      case 'export':
        _exportToPDF(exam);
        break;
      case 'share':
        _shareExam(exam);
        break;
      case 'delete':
        _deleteExam(exam);
        break;
    }
  }

  void _exportToPDF(Map<String, dynamic> exam) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đang xuất PDF cho ${exam['title']}...'),
        action: SnackBarAction(
          label: 'Hủy',
          onPressed: () {
            // Cancel export
          },
        ),
      ),
    );
  }

  void _shareExam(Map<String, dynamic> exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chia sẻ đề thi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Sao chép liên kết'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép liên kết')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Gửi email'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mở ứng dụng email')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Chia sẻ khác'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mở menu chia sẻ')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void _deleteExam(Map<String, dynamic> exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa đề thi'),
        content: Text('Bạn có chắc chắn muốn xóa "${exam['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                savedExams.removeWhere((e) => e['id'] == exam['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã xóa ${exam['title']}'),
                  action: SnackBarAction(
                    label: 'Hoàn tác',
                    onPressed: () {
                      setState(() {
                        savedExams.add(exam);
                      });
                    },
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tìm kiếm đề thi'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Nhập từ khóa tìm kiếm...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // Implement search logic
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement search
            },
            child: const Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lọc đề thi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add filter options here
            const Text('Tính năng lọc sẽ được thêm sau'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }
} 