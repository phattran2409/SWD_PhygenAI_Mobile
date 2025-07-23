import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/ChatAI/bloc/exam_generation_bloc.dart';
import 'package:phygen/features/Exam/bloc/upload_bloc.dart';
import 'injection_container.dart' as di;  


class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>(),
    ),
    BlocProvider<UploadBloc>(
      create: (context) => di.sl<UploadBloc>(),
    ),
    BlocProvider<ExamGenerationBloc>(
      create: (context) => di.sl<ExamGenerationBloc>(),
    ),
  ];
}