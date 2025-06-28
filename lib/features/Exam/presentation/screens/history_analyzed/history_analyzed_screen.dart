import 'package:flutter/material.dart';

class HistoryAnalyzedScreen extends StatefulWidget {
  const HistoryAnalyzedScreen({Key? key}) : super(key: key);

  @override
  State<HistoryAnalyzedScreen> createState() => _HistoryAnalyzedScreenState();
}

class _HistoryAnalyzedScreenState extends State<HistoryAnalyzedScreen> {
  List<Map<String, dynamic>> analyzedFiles = [];
  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadAnalyzedFiles();
  }

  void _loadAnalyzedFiles() {
    // Mock data - replace with actual data loading
    analyzedFiles = [
      {
        'id': '1',
        'fileName': 'de_thi_toan_lop11.pdf',
        'fileSize': '2.5 MB',
        'uploadDate': '2024-01-15',
        'analyzedDate': '2024-01-15',
        'status': 'completed',
        'grade': 'Lớp 11',
        'chapter': 'Chương 2',
        'type': 'Trắc nghiệm',
        'difficulty': 'Trung bình',
        'questionCount': 15,
        'extractedContent': 'Nội dung câu hỏi được trích xuất từ file...',
      },
      {
        'id': '2',
        'fileName': 'de_thi_vat_ly_lop12.docx',
        'fileSize': '1.8 MB',
        'uploadDate': '2024-01-14',
        'analyzedDate': '2024-01-14',
        'status': 'completed',
        'grade': 'Lớp 12',
        'chapter': 'Chương 1',
        'type': 'Kết hợp',
        'difficulty': 'Khó',
        'questionCount': 20,
        'extractedContent': 'Nội dung câu hỏi được trích xuất từ file...',
      },
      {
        'id': '3',
        'fileName': 'de_thi_hoa_hoc_lop10.jpg',
        'fileSize': '3.2 MB',
        'uploadDate': '2024-01-13',
        'analyzedDate': '2024-01-13',
        'status': 'completed',
        'grade': 'Lớp 10',
        'chapter': 'Chương 3',
        'type': 'Tự luận',
        'difficulty': 'Dễ',
        'questionCount': 12,
        'extractedContent': 'Nội dung câu hỏi được trích xuất từ file...',
      },
      {
        'id': '4',
        'fileName': 'de_thi_sinh_hoc_lop11.png',
        'fileSize': '4.1 MB',
        'uploadDate': '2024-01-12',
        'analyzedDate': '2024-01-12',
        'status': 'completed',
        'grade': 'Lớp 11',
        'chapter': 'Chương 4',
        'type': 'Trắc nghiệm',
        'difficulty': 'Trung bình',
        'questionCount': 18,
        'extractedContent': 'Nội dung câu hỏi được trích xuất từ file...',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử phân tích'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Tất cả'),
              ),
              const PopupMenuItem(
                value: 'recent',
                child: Text('Gần đây'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Đã hoàn thành'),
              ),
              const PopupMenuItem(
                value: 'failed',
                child: Text('Thất bại'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 4),
                  Text(_getFilterText(selectedFilter)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: analyzedFiles.isEmpty
          ? _buildEmptyState()
          : _buildAnalyzedFilesList(),
    );
  }

  String _getFilterText(String filter) {
    switch (filter) {
      case 'all':
        return 'Tất cả';
      case 'recent':
        return 'Gần đây';
      case 'completed':
        return 'Đã hoàn thành';
      case 'failed':
        return 'Thất bại';
      default:
        return 'Tất cả';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có file nào được phân tích',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Các file bạn upload và phân tích sẽ xuất hiện ở đây',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/upload');
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload file mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzedFilesList() {
    final filteredFiles = _getFilteredFiles();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFiles.length,
      itemBuilder: (context, index) {
        final file = filteredFiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: InkWell(
            onTap: () => _viewAnalyzedFile(file),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File header
                  Row(
                    children: [
                      _getFileIcon(file['fileName']),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file['fileName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.storage, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  file['fileSize'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  file['analyzedDate'],
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
                      _buildStatusChip(file['status']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Analysis results
                  _buildAnalysisResults(file),
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  _buildActionButtons(file),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    IconData iconData;
    Color iconColor;
    
    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'docx':
      case 'doc':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    IconData icon;
    
    switch (status) {
      case 'completed':
        color = Colors.green;
        text = 'Hoàn thành';
        icon = Icons.check_circle;
        break;
      case 'processing':
        color = Colors.orange;
        text = 'Đang xử lý';
        icon = Icons.hourglass_empty;
        break;
      case 'failed':
        color = Colors.red;
        text = 'Thất bại';
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        text = 'Không xác định';
        icon = Icons.help;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults(Map<String, dynamic> file) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kết quả phân tích:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildResultChip('Lớp', file['grade'], Colors.blue),
              _buildResultChip('Chương', file['chapter'], Colors.green),
              _buildResultChip('Dạng', file['type'], Colors.orange),
              _buildResultChip('Độ khó', file['difficulty'], _getDifficultyColor(file['difficulty'])),
              _buildResultChip('${file['questionCount']} câu', '', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip(String label, String value, Color color) {
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

  Widget _buildActionButtons(Map<String, dynamic> file) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewAnalyzedFile(file),
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Xem chi tiết'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _generateExamFromFile(file),
            icon: const Icon(Icons.auto_awesome, size: 16),
            label: const Text('Tạo đề thi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredFiles() {
    switch (selectedFilter) {
      case 'recent':
        // Filter files from last 7 days
        final now = DateTime.now();
        return analyzedFiles.where((file) {
          final fileDate = DateTime.parse(file['analyzedDate']);
          return now.difference(fileDate).inDays <= 7;
        }).toList();
      case 'completed':
        return analyzedFiles.where((file) => file['status'] == 'completed').toList();
      case 'failed':
        return analyzedFiles.where((file) => file['status'] == 'failed').toList();
      default:
        return analyzedFiles;
    }
  }

  void _viewAnalyzedFile(Map<String, dynamic> file) {
    Navigator.pushNamed(
      context,
      '/analyze',
      arguments: {
        'fileId': file['id'],
        'extractedContent': file['extractedContent'],
        'analysisResults': {
          'grade': file['grade'],
          'chapter': file['chapter'],
          'type': file['type'],
          'difficulty': file['difficulty'],
          'questionCount': file['questionCount'],
        }
      },
    );
  }

  void _generateExamFromFile(Map<String, dynamic> file) {
    Navigator.pushNamed(
      context,
      '/generate-exam',
      arguments: {
        'sourceFile': file,
        'prefilledData': {
          'grade': file['grade'],
          'chapter': file['chapter'],
          'type': file['type'],
          'difficulty': file['difficulty'],
        }
      },
    );
  }
} 