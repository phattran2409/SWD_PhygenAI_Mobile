import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_set_detail_bloc.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_set_detail_event.dart';
import 'package:phygen/features/Exam/ExamSaved/bloc/exam_set_detail_state.dart';
import 'package:phygen/features/Exam/ExamSaved/model/exam_set_detail_model.dart';

class ExamPreviewScreen extends StatefulWidget {
  const ExamPreviewScreen({Key? key}) : super(key: key);

  @override
  State<ExamPreviewScreen> createState() => _ExamPreviewScreenState();
}

class _ExamPreviewScreenState extends State<ExamPreviewScreen> {
  String? examId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['examId'] != null) {
      examId = args['examId'];
      context.read<ExamSetDetailBloc>().add(FetchExamSetDetailEvent(examId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Detail'),
        backgroundColor: const Color(0xFF9F5FFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3E8FF),
      body: BlocBuilder<ExamSetDetailBloc, ExamSetDetailState>(
        builder: (context, state) {
          if (state is ExamSetDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamSetDetailError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is ExamSetDetailLoaded) {
            return _buildExamDetail(state.examSetDetail);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExamDetail(ExamSetDetailModel detail) {
    return Column(
      children: [
        _buildHeader(detail),
        Expanded(child: _buildQuestionsList(detail.examSetQuestions)),
      ],
    );
  }

  Widget _buildHeader(ExamSetDetailModel detail) {
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
                    detail.title,
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
                _buildChip('Class: 11', Colors.blue),
                _buildChip('Status: ${detail.status}', Colors.green),
                _buildChip('Questions: ${detail.examSetQuestions.length}', Colors.purple),
              ],
            ),
            if (detail.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                detail.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Created: ${_formatDate(detail.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildQuestionsList(List<ExamSetQuestionModel> questions) {
    if (questions.isEmpty) {
      return const Center(child: Text('No questions found', style: TextStyle(fontSize: 16, color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        final question = q.question;
        final option = question.questionOptionSet;
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
                      child: Text(
                        question.questionContent,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (option != null) ...[
                  _buildOption('A', option.a, option.correct == 'A'),
                  _buildOption('B', option.b, option.correct == 'B'),
                  _buildOption('C', option.c, option.correct == 'C'),
                  _buildOption('D', option.d, option.correct == 'D'),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildChip('Chapter: ${question.chapterId}', Colors.orange),
                    const SizedBox(width: 8),
                    _buildChip('Topic: ${question.topicId}', Colors.teal),
                    const SizedBox(width: 8),
                    _buildChip('Difficulty: ${question.difficulty}', Colors.red),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Created: ${_formatDate(question.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(String letter, String text, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isCorrect ? Colors.green[700] : Colors.black87,
                fontWeight: isCorrect ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (isCorrect)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}