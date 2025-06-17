import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'injection_container.dart' as di;  


class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>(),
    ),
  ];
}