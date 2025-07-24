import 'package:flutter/material.dart';
import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';

class ExamPreviewScreen extends StatefulWidget {
  final List<ExamQuestionModel>? examQuestions;

  const ExamPreviewScreen({Key? key, this.examQuestions}) : super(key: key);

  @override
  State<ExamPreviewScreen> createState() => _ExamPreviewScreenState();
}

class _ExamPreviewScreenState extends State<ExamPreviewScreen> {
  List<ExamQuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  void _initializeQuestions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;

      if (routeArgs is List<ExamQuestionModel>) {
        setState(() {
          questions = routeArgs;
        });
      } else if (widget.examQuestions != null) {
        setState(() {
          questions = widget.examQuestions!;
        });
      } else {
        setState(() {
          questions = [];
        });
      }
    });

    if (widget.examQuestions != null) {
      questions = widget.examQuestions!;
    } else {
      questions = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem trước đề thi'),
        backgroundColor: const Color(0xFF9F5FFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3E8FF),
      body:
          questions.isEmpty
              ? const Center(
                child: Text(
                  'Không có câu hỏi nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildQuestionsList()),
                  _buildBottomActions(),
                ],
              ),
    );
  }

  Widget _buildHeader() {
    if (questions.isEmpty) return const SizedBox.shrink();

    final firstQuestion = questions.first;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.quiz, color: Color(0xFF9F5FFF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đề thi ${firstQuestion.className} - ${firstQuestion.chapterName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9F5FFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                _buildChip('📚 ${firstQuestion.className}', Colors.blue),
                _buildChip('📖 ${firstQuestion.chapterName}', Colors.green),
                _buildChip('🔢 ${questions.length} câu', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
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
        print('Question object: $question');
        print(
          'Question at $index: ${question.question}',
        ); // Log giá trị question.question
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9F5FFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${question.className} • ${question.chapterName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // ✅ Question với Regular Text + Unicode formatting
                          Text(
                            question.question ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'monospace', // hoặc bỏ nếu không cần
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Options với Regular Text + Unicode formatting
                _buildOption('A', question.a, question.answer == 'A'),
                _buildOption('B', question.b, question.answer == 'B'),
                _buildOption('C', question.c, question.answer == 'C'),
                _buildOption('D', question.d, question.answer == 'D'),

                // Topic info
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9F5FFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Chủ đề: ${question.topicName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF9F5FFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Updated _buildOption với Regular Text
  Widget _buildOption(String letter, String text, bool isCorrect) {
    print('Option $letter: $text'); // Log giá trị text
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isCorrect
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isCorrect
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : const Color(0xFF9F5FFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ✅ Expanded với Regular Text + Unicode formatting
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isCorrect ? Colors.green[700] : Colors.black87,
                fontWeight: isCorrect ? FontWeight.w500 : FontWeight.normal,
                fontFamily: 'monospace', // hoặc bỏ nếu không cần
              ),
            ),
          ),

          if (isCorrect)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF9F5FFF),
                side: const BorderSide(color: Color(0xFF9F5FFF)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('💾 Đã lưu đề thi!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Lưu đề thi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F5FFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
