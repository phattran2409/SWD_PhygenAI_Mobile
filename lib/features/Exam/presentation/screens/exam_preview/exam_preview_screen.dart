import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExamPreviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>>? questions;
  final Map<String, dynamic>? examInfo;

  const ExamPreviewScreen({
    Key? key,
    this.questions,
    this.examInfo,
  }) : super(key: key);

  @override
  State<ExamPreviewScreen> createState() => _ExamPreviewScreenState();
}

class _ExamPreviewScreenState extends State<ExamPreviewScreen> {
  late List<Map<String, dynamic>> questions;
  late Map<String, dynamic> examInfo;
  bool isEditing = false;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    questions = widget.questions ?? _getDefaultQuestions();
    examInfo = widget.examInfo ?? _getDefaultExamInfo();
    _titleController.text = examInfo['title'] ?? 'Đề thi mới';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem trước đề thi'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                if (!isEditing) {
                  // Save changes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu thay đổi')),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header với thông tin đề thi
          _buildExamHeader(),
          
          // Danh sách câu hỏi
          Expanded(
            child: _buildQuestionsList(),
          ),
          
          // Bottom actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildExamHeader() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isEditing)
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập tiêu đề đề thi',
                ),
              )
            else
              Text(
                _titleController.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Lớp', examInfo['grade'] ?? 'N/A'),
                const SizedBox(width: 8),
                _buildInfoChip('Chương', examInfo['chapter'] ?? 'N/A'),
                const SizedBox(width: 8),
                _buildInfoChip('Dạng', examInfo['type'] ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoChip('Độ khó', examInfo['difficulty'] ?? 'N/A'),
                const SizedBox(width: 8),
                _buildInfoChip('Số câu', '${questions.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQuestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question number and content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${question['id']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: isEditing
                        ? TextField(
                            controller: TextEditingController(text: question['question']),
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nhập câu hỏi',
                            ),
                            onChanged: (value) {
                              questions[index]['question'] = value;
                            },
                          )
                        : Text(
                            question['question'],
                            style: const TextStyle(fontSize: 14),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Options
                if (question['options'] != null) ...[
                  ...List.generate(question['options'].length, (optionIndex) {
                    final option = question['options'][optionIndex];
                    final optionLetter = String.fromCharCode(65 + optionIndex);
                    final isCorrect = question['correctAnswer'] == optionLetter;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                optionLetter,
                                style: TextStyle(
                                  color: isCorrect ? Colors.white : Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: isEditing
                              ? TextField(
                                  controller: TextEditingController(text: option),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nhập lựa chọn',
                                  ),
                                  onChanged: (value) {
                                    questions[index]['options'][optionIndex] = value;
                                  },
                                )
                              : Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCorrect ? Colors.green[700] : null,
                                    fontWeight: isCorrect ? FontWeight.w500 : null,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                
                // Explanation (if available)
                if (question['explanation'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giải thích:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        isEditing
                          ? TextField(
                              controller: TextEditingController(text: question['explanation']),
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nhập giải thích',
                              ),
                              onChanged: (value) {
                                questions[index]['explanation'] = value;
                              },
                            )
                          : Text(
                              question['explanation'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Export to PDF
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đang xuất PDF...')),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Xuất PDF'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Save to system
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã lưu vào hệ thống')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Lưu đề thi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDefaultQuestions() {
    return [
      {
        'id': 1,
        'question': 'Câu hỏi mẫu 1: Đây là nội dung câu hỏi mẫu.',
        'options': ['A. Lựa chọn A', 'B. Lựa chọn B', 'C. Lựa chọn C', 'D. Lựa chọn D'],
        'correctAnswer': 'A',
        'explanation': 'Giải thích cho câu hỏi 1',
      },
      {
        'id': 2,
        'question': 'Câu hỏi mẫu 2: Đây là nội dung câu hỏi mẫu thứ hai.',
        'options': ['A. Lựa chọn A', 'B. Lựa chọn B', 'C. Lựa chọn C', 'D. Lựa chọn D'],
        'correctAnswer': 'B',
        'explanation': 'Giải thích cho câu hỏi 2',
      },
    ];
  }

  Map<String, dynamic> _getDefaultExamInfo() {
    return {
      'title': 'Đề thi mẫu',
      'grade': 'Lớp 11',
      'chapter': 'Chương 2',
      'type': 'Trắc nghiệm',
      'difficulty': 'Trung bình',
      'questionCount': 2,
    };
  }
} 