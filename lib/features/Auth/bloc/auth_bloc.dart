import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_event.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Auth/domain/usecases/google_signIn_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/login_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final GoogleSignInUsecase googleSignInUsecase;
  AuthBloc({required this.loginUsecase, required this.googleSignInUsecase}) : super(AuthInitialState()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await loginUsecase(event.email, event.password);

        if (user != null) {
          // Assuming user is of type UserModel
          emit(AuthSuccessState(message: 'Login successful'));
        } else {
          emit(AuthErrorState(message: 'Login failed'));
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });

    on<AuthSignupEvent>((event, emit) async {
      // Handle signup logic here
    });

    on<AuthGoogleSignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await googleSignInUsecase();
        if (user != null) {
          emit(AuthSuccessState(message: 'Google login successful'));
        } else {
          emit(AuthErrorState(message: 'Google login failed'));
        }
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }
}
