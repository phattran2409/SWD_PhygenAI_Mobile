import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phygen/data/TestExamData.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_bloc.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_event.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_state.dart';
import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';

class ChatAI extends StatefulWidget {
  const ChatAI({super.key});

  @override
  State<ChatAI> createState() => _ChatAIState();
}

class _ChatAIState extends State<ChatAI> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  String _username = 'Bạn';
  bool _isPrompting = false;

  @override
  void initState() {
    super.initState();
    _getUsernameAndAddWelcome();
  }

  void _getUsernameAndAddWelcome() {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthLoggedInState) {
      setState(() {
        _username =
            authState.user.username ??
            authState.user.email?.split('@')[0] ??
            'Bạn';
      });
    }

    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final now = DateTime.now();
    String greeting;
    final hour = now.hour;

    if (hour < 11) {
      greeting = "Chào buổi sáng 👋";
    } else if (hour < 14) {
      greeting = "Chào buổi trưa ☀️";
    } else if (hour < 18) {
      greeting = "Chào buổi chiều 🌇";
    } else {
      greeting = "Chào buổi tối 🌙";
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text:
              "$greeting $_username!\nWelcome back! Tôi là AI Assistant. Hãy nhập 'generate exam' để bắt đầu tạo đề thi!",
          isUser: false,
          isWelcome: true,
        ),
      );
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
    });
    _controller.clear();

    if (!_isPrompting) {
      if (text.toLowerCase().contains('generate exam') ||
          text.toLowerCase().contains('tạo đề')) {
        setState(() {
          _isPrompting = true;
          _messages.add(
            _ChatMessage(
              text:
                  '📝 Tuyệt vời! Hãy mô tả chi tiết đề thi bạn muốn tạo.\n\n'
                  'Ví dụ:\n'
                  '• "Tạo đề Vật lý lớp 12, gồm 15 câu hỏi trắc nghiệm, chương dao động"\n'
                  '• "Đề Toán lớp 10, 20 câu, khó, có 5 câu chương hàm số"\n'
                  '• "Tạo đề Hóa học, lớp 11, 10 câu dễ về bảng tuần hoàn"',
              isUser: false,
            ),
          );
        });
      } else {
        setState(() {
          _messages.add(
            _ChatMessage(
              text:
                  '🤖 $_username ơi, để bắt đầu tạo đề thi, hãy nhập "generate exam" hoặc "tạo đề thi".',
              isUser: false,
            ),
          );
        });
      }
    } else {
      _sendPromptToAPI(text);
    }
  }

  void _sendPromptToAPI(String prompt) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthLoggedInState) {
      // Nếu chưa đăng nhập, chuyển về trang login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }
    setState(() {
      _messages.add(
        _ChatMessage(
          text: '⏳ Đang xử lý yêu cầu: "$prompt"...\nVui lòng đợi một chút!',
          isUser: false,
          isLoading: true,
        ),
      );
    });
    // Test Data
    Future.delayed(const Duration(seconds: 2), () {
      final testQuestions = _generateTestQuestions(prompt);

      setState(() {
        _messages.removeWhere((msg) => msg.isLoading);
        _messages.add(
          _ChatMessage(
            text:
                '✅ Đề thi đã được tạo thành công!\n\n'
                '📊 Tổng số câu hỏi: ${testQuestions.length}\n'
                '📚 Prompt: "$prompt"\n\n'
                '👆 Nhấn vào đây để xem đề thi chi tiết.',
            isUser: false,
            isExam: true,
            examQuestions: testQuestions,
          ),
        );
        _isPrompting = false;
      });
    });

    // ✅ Gọi BLoC để generate exam
    // context.read<ExamGenerationBloc>().add(
    //   GenerateExamEvent(prompt: prompt),
    // );
  }

  List<ExamQuestionModel> _generateTestQuestions(String prompt) {
    String lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains('vật lý') || lowerPrompt.contains('physics')) {
      return _getPhysicsQuestions();
    }
    // Return an empty list if no condition matches
    return [];
  }

  List<ExamQuestionModel> _getPhysicsQuestions() {
    return TestExamData.getPhysicsQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      body: Column(
        children: [
          _buildHeader(),

          // ✅ Chat messages với BlocListener
          Expanded(
            child: BlocListener<ExamGenerationBloc, ExamGenerationState>(
              listener: (context, state) {
                if (state is ExamGenerationSuccessState) {
                  setState(() {
                    // Remove loading message
                    _messages.removeWhere((msg) => msg.isLoading);

                    // Add success message
                    _messages.add(
                      _ChatMessage(
                        text:
                            '✅ Đề thi đã được tạo thành công!\n\n'
                            '📊 Tổng số câu hỏi: ${state.questions.length}\n'
                            '📚 Prompt: "${state.prompt}"\n\n'
                            '👆 Nhấn vào đây để xem đề thi chi tiết.',
                        isUser: false,
                        isExam: true,
                        examQuestions: state.questions,
                      ),
                    );
                    _isPrompting = false;
                  });
                } else if (state is ExamGenerationErrorState) {
                  setState(() {
                    // Remove loading message
                    _messages.removeWhere((msg) => msg.isLoading);

                    // Add error message
                    _messages.add(
                      _ChatMessage(
                        text:
                            '❌ Lỗi tạo đề thi!\n\n'
                            '📝 Lỗi: ${state.message}\n\n'
                            '🔄 Hãy thử lại với prompt khác hoặc kiểm tra kết nối mạng.',
                        isUser: false,
                        isError: true,
                      ),
                    );
                    _isPrompting = false;
                  });
                } else if (state is ExamGenerationLoadingState) {
                  // Update loading message if needed
                  if (state.loadingMessage != null) {
                    setState(() {
                      final loadingIndex = _messages.indexWhere(
                        (msg) => msg.isLoading,
                      );
                      if (loadingIndex != -1) {
                        _messages[loadingIndex] = _ChatMessage(
                          text: state.loadingMessage!,
                          isUser: false,
                          isLoading: true,
                        );
                      }
                    });
                  }
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          ),

          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 40, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9F5FFF).withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF9F5FFF),
                    child: Text(
                      _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'AI Exam Generator',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF9F5FFF),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Chat với $_username',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ✅ BLoC state indicator
            BlocBuilder<ExamGenerationBloc, ExamGenerationState>(
              builder: (context, state) {
                if (state is ExamGenerationLoadingState) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                } else if (state is ExamGenerationSuccessState) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                } else if (state is ExamGenerationErrorState) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment:
              msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isUser) ...[
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(
                  msg.isLoading
                      ? Icons.hourglass_empty
                      : (msg.isExam
                          ? Icons.quiz
                          : (msg.isError
                              ? Icons.error_outline
                              : Icons.smart_toy)),
                  color:
                      msg.isLoading
                          ? Colors.orange
                          : (msg.isExam
                              ? Colors.green
                              : (msg.isError
                                  ? Colors.red
                                  : const Color(0xFF9F5FFF))),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: GestureDetector(
                onTap:
                    msg.isExam && msg.examQuestions != null
                        ? () {
                          // ✅ Navigate to exam view with questions
                          Navigator.pushNamed(
                            context,
                            '/view-exam',
                            arguments: msg.examQuestions,
                          );
                        }
                        : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  margin:
                      msg.isUser
                          ? const EdgeInsets.only(left: 40)
                          : const EdgeInsets.only(right: 40),
                  decoration: BoxDecoration(
                    color:
                        msg.isUser
                            ? const Color(0xFFD1B3FF)
                            : (msg.isExam
                                ? const Color(0xFFB388FF)
                                : (msg.isError
                                    ? Colors.red.withOpacity(0.1)
                                    : (msg.isLoading
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.white))),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
                      bottomRight: Radius.circular(msg.isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              msg.text,
                              style: TextStyle(
                                color:
                                    msg.isUser
                                        ? Colors.black
                                        : (msg.isError
                                            ? Colors.red[700]
                                            : Colors.deepPurple),
                                fontWeight:
                                    msg.isExam || msg.isWelcome
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                decoration:
                                    msg.isExam
                                        ? TextDecoration.underline
                                        : null,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (msg.isLoading) ...[
                            const SizedBox(width: 8),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (msg.timestamp != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(msg.timestamp!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (msg.isUser) ...[
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFD1B3FF),
                child: Text(
                  _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:
                    _isPrompting
                        ? 'Mô tả đề thi bạn muốn tạo...'
                        : 'Nhập "generate exam" để bắt đầu...',
                border: InputBorder.none,
                prefixIcon: Icon(
                  _isPrompting ? Icons.edit : Icons.chat_bubble_outline,
                  color: Colors.grey[400],
                ),
              ),
              onSubmitted: _sendMessage,
              maxLines: null,
            ),
          ),
          BlocBuilder<ExamGenerationBloc, ExamGenerationState>(
            builder: (context, state) {
              return IconButton(
                icon:
                    state is ExamGenerationLoadingState
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.send, color: Color(0xFF9F5FFF)),
                onPressed:
                    state is ExamGenerationLoadingState
                        ? null
                        : () => _sendMessage(_controller.text),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isExam;
  final bool isWelcome;
  final bool isLoading;
  final bool isError;
  final DateTime? timestamp;
  final List<ExamQuestionModel>? examQuestions;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isExam = false,
    this.isWelcome = false,
    this.isLoading = false,
    this.isError = false,
    DateTime? timestamp,
    this.examQuestions,
  }) : timestamp = timestamp ?? DateTime.now();
}
