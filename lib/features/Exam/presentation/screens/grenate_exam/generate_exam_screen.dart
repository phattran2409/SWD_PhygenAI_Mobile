import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_State.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';

class GenerateExamScreen extends StatefulWidget {
  const GenerateExamScreen({Key? key}) : super(key: key);

  @override
  State<GenerateExamScreen> createState() => _GenerateExamScreenState();
}

class _GenerateExamScreenState extends State<GenerateExamScreen> {
  String? selectedGrade;
  String? selectedChapter;
  String? selectedType;
  String? selectedDifficulty;
  int questionCount = 10;
  bool isLoading = false;

  final List<String> grades = ['Lớp 10', 'Lớp 11', 'Lớp 12'];
  final List<String> chapters = ['Chương 1', 'Chương 2', 'Chương 3', 'Chương 4', 'Chương 5'];
  final List<String> types = ['Trắc nghiệm', 'Tự luận', 'Kết hợp'];
  final List<String> difficulties = ['Dễ', 'Trung bình', 'Khó', 'Rất khó'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo đề thi mới'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadErrorState) {
            setState(() => isLoading = false);
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
              // Header
              _buildHeader(),
              const SizedBox(height: 24),
              
              // Form tùy chọn
              _buildOptionsForm(),
              const SizedBox(height: 32),
              
              // Nút tạo đề thi
              _buildGenerateButton(),
              const SizedBox(height: 24),
              
              // Kết quả (nếu có)
              if (isLoading) _buildLoadingSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.quiz, color: Colors.green[600], size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tạo đề thi mới',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chọn các tiêu chí để sinh đề thi tự động',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiêu chí đề thi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Lớp học
            _buildDropdownField('Lớp học', grades, selectedGrade, (value) {
              setState(() => selectedGrade = value);
            }),
            const SizedBox(height: 16),
            
            // Chương
            _buildDropdownField('Chương', chapters, selectedChapter, (value) {
              setState(() => selectedChapter = value);
            }),
            const SizedBox(height: 16),
            
            // Dạng bài
            _buildDropdownField('Dạng bài', types, selectedType, (value) {
              setState(() => selectedType = value);
            }),
            const SizedBox(height: 16),
            
            // Độ khó
            _buildDropdownField('Độ khó', difficulties, selectedDifficulty, (value) {
              setState(() => selectedDifficulty = value);
            }),
            const SizedBox(height: 16),
            
            // Số lượng câu hỏi
            _buildQuestionCountSlider(),
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

  Widget _buildQuestionCountSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Số lượng câu hỏi: $questionCount',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: questionCount.toDouble(),
          min: 5,
          max: 50,
          divisions: 9,
          activeColor: Colors.green[600],
          onChanged: (value) {
            setState(() {
              questionCount = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('5', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('50', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _canGenerate() && !isLoading ? _generateExam : null,
        icon: isLoading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.auto_awesome),
        label: Text(isLoading ? 'Đang tạo đề thi...' : 'Tạo đề thi'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Đang tạo đề thi với $questionCount câu hỏi...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canGenerate() {
    return selectedGrade != null &&
           selectedChapter != null &&
           selectedType != null &&
           selectedDifficulty != null;
  }

  void _generateExam() {
    setState(() => isLoading = true);
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => isLoading = false);
      
      // Navigate to exam preview with generated questions
      Navigator.pushNamed(
        context, 
        '/exam-preview',
        arguments: {
          'questions': _generateMockQuestions(),
          'examInfo': {
            'grade': selectedGrade,
            'chapter': selectedChapter,
            'type': selectedType,
            'difficulty': selectedDifficulty,
            'questionCount': questionCount,
          }
        },
      );
    });
  }

  List<Map<String, dynamic>> _generateMockQuestions() {
    return List.generate(questionCount, (index) {
      return {
        'id': index + 1,
        'question': 'Câu hỏi ${index + 1}: Đây là nội dung câu hỏi mẫu được tạo tự động.',
        'options': ['A. Lựa chọn A', 'B. Lựa chọn B', 'C. Lựa chọn C', 'D. Lựa chọn D'],
        'correctAnswer': 'A',
        'explanation': 'Giải thích cho câu hỏi ${index + 1}',
      };
    });
  }
} 