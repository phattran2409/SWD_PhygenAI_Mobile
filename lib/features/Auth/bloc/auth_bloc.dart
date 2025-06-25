import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_event.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Auth/domain/usecases/login_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/logout_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/signup_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/google_signIn_usecase.dart';
import 'package:phygen/features/Auth/domain/entities/user.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final SignUpUseCase signUpUseCase;
  final GoogleSignInUsecase googleSignInUsecase;
  final LogoutUsecase logoutUsecase; 
  AuthBloc({
    required this.loginUsecase,
    required this.signUpUseCase,
    required this.googleSignInUsecase,
    required this.logoutUsecase,  
  }) : super(AuthInitialState()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthSignupEvent>(_onAuthSignupEvent);
    on<AuthGoogleSignInEvent>(_onAuthGoogleSignInEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthCheckStatusEvent>(_onAuthCheckStatusEvent);
   
  }

  // ✅ Login event handler
  Future<void> _onAuthLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await loginUsecase(event.email, event.password);

      if (user != null) {
        emit(AuthLoggedInState(user: user , message: 'Login successful')); 
      } else {
        emit(AuthErrorState(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onAuthSignupEvent(
    AuthSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await signUpUseCase(
        event.email,
        event.password,
        event.username,
      );

      if (user != null) {
        // ✅ Sau khi signup thành công, lưu user info
        emit(AuthSuccessState(message: 'Signup successful'));
      } else {
        emit(AuthErrorState(message: 'Signup failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onAuthGoogleSignInEvent(
    AuthGoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await googleSignInUsecase();

      if (user != null) {
        emit(AuthLoggedInState(user: user , message: 'Google login successful'));
      } else {
        emit(AuthErrorState(message: 'Google login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
  try {
      emit(AuthLoadingState());
      
      // Chỉ cần xóa token
      await logoutUsecase();  
      
      // Clear HydratedBloc storage
      await clear();
      
      emit(AuthLoggedOutState());
      
    } catch (e) {
      emit(AuthErrorState(message: 'Logout failed'));
    }
    }
  

  // Check auth status khi app khởi động
  Future<void> _onAuthCheckStatusEvent(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    // HydratedBloc sẽ tự động restore state từ storage
    // Không cần implement gì thêm
  }

  //  Serialize state để lưu vào storage
  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthLoggedInState) {
      return {'type': 'AuthLoggedInState', 'user': state.user.toJson()};
    }
    // Chỉ lưu AuthLoggedInState, các state khác không lưu
    return null;
  }

  // ✅ Deserialize state từ storage
  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'AuthLoggedInState') {
        return AuthLoggedInState(user: User.fromJson(json['user']));
      }
    } catch (e) {
      print('Error deserializing auth state: $e');
    }
    return null;
  }
}
