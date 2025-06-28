import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_State.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';

class AnalyzeScreen extends StatefulWidget {
  final String? filePath;
  final String? extractedContent;

  const AnalyzeScreen({
    Key? key,
    this.filePath,
    this.extractedContent,
  }) : super(key: key);

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  String? selectedGrade;
  String? selectedChapter;
  String? selectedType;
  String? selectedDifficulty;

  final List<String> grades = ['Lớp 10', 'Lớp 11', 'Lớp 12'];
  final List<String> chapters = ['Chương 1', 'Chương 2', 'Chương 3', 'Chương 4', 'Chương 5'];
  final List<String> types = ['Trắc nghiệm', 'Tự luận', 'Kết hợp'];
  final List<String> difficulties = ['Dễ', 'Trung bình', 'Khó', 'Rất khó'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích câu hỏi'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần hiển thị nội dung được trích xuất
              _buildExtractedContentSection(),
              const SizedBox(height: 24),
              
              // Phần tự động nhận dạng
              _buildAutoRecognitionSection(),
              const SizedBox(height: 24),
              
              // Phần điều chỉnh thủ công
              _buildManualAdjustmentSection(),
              const SizedBox(height: 32),
              
              // Nút hành động
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtractedContentSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'Nội dung được trích xuất',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                widget.extractedContent ?? 'Đang tải nội dung...',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoRecognitionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.green[600]),
                const SizedBox(width: 8),
                const Text(
                  'Tự động nhận dạng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecognitionItem('Lớp học', 'Lớp 11', Icons.school),
            _buildRecognitionItem('Chương', 'Chương 2', Icons.book),
            _buildRecognitionItem('Dạng bài', 'Trắc nghiệm', Icons.quiz),
            _buildRecognitionItem('Độ khó', 'Trung bình', Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildRecognitionItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualAdjustmentSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'Điều chỉnh thủ công',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownField('Lớp học', grades, selectedGrade, (value) {
              setState(() => selectedGrade = value);
            }),
            const SizedBox(height: 12),
            _buildDropdownField('Chương', chapters, selectedChapter, (value) {
              setState(() => selectedChapter = value);
            }),
            const SizedBox(height: 12),
            _buildDropdownField('Dạng bài', types, selectedType, (value) {
              setState(() => selectedType = value);
            }),
            const SizedBox(height: 12),
            _buildDropdownField('Độ khó', difficulties, selectedDifficulty, (value) {
              setState(() => selectedDifficulty = value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text('Chọn $label'),
              isExpanded: true,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Xử lý lưu phân tích
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu phân tích')),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Lưu phân tích'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Chuyển đến màn hình tạo đề thi
              Navigator.pushNamed(context, '/generate-exam');
            },
            icon: const Icon(Icons.add),
            label: const Text('Tạo đề thi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
} 