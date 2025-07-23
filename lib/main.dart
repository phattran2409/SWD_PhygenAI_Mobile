import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phygen/core/constants/api_firebase.dart';
import 'package:phygen/core/di/bloc_provider.dart';
import 'package:phygen/core/services/local_notification_services.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Auth/presentation/pages/signupPage.dart';
import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';
import 'package:phygen/features/ChatAI/presentation/screens/ChatAI.dart';
import 'package:phygen/features/Error/Error_page.dart';
import 'package:phygen/features/Exam/presentation/screens/exam_preview/exam_preview_screen.dart';
import 'package:phygen/features/Exam/presentation/screens/grenate_exam/generate_exam_screen.dart';
import 'package:phygen/features/Home/homePage.dart';
import 'package:phygen/features/Profile/presentation/profilePages.dart';
import 'features/Auth/presentation/pages/loginPages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/Exam/presentation/screens/upload/upload_screen.dart';
import 'features/Exam/presentation/screens/demo_screens.dart';
import 'core/di/injection_container.dart' as di;
import 'package:firebase_messaging/firebase_messaging.dart';

// ✅ Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📱 Background message: ${message.messageId}');
}
void main() async {
  // ✅ STEP 1: Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ STEP 2: Set orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // ✅ STEP 3: Initialize HydratedStorage ONCE ONLY
    final storageDir = await getApplicationDocumentsDirectory();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: storageDir,
    );
    print('💾 HydratedStorage initialized: ${storageDir.path}');

    // ✅ STEP 4: Initialize Firebase
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    print('🔥 Firebase initialized');

    // ✅ STEP 5: Initialize Firebase Messaging
    await FirebaseMessageApi().initializeFirebaseMessaging();
    print('📱 FCM initialized');
    // ✅ STEP 6: Initialize Local Notifications
    await LocalNotificationServices.initialize();
    print('🔔 Local notifications initialized');

    // ✅ STEP 7: Initialize dependency injection
    await di.init();
    print('💉 DI initialized');

    // ✅ STEP 8: Set Bloc observer
    Bloc.observer = AppBlocObserver();

    // ✅ STEP 9: Run app
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('❌ Error initializing app: $e');
    print('📍 Stack trace: $stackTrace');

  }
}

// Bloc Observer to monitor Bloc events and states
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('🟢 Bloc Created: ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(
      '🔄 ${bloc.runtimeType}: ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ ${bloc.runtimeType} Error: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Phygen AI',
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                inversePrimary: Colors.white,
              ),
              useMaterial3: true,
            ),
            home: AuthWrapper(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/upload': (context) => const UploadScreen(),
              '/profile': (context) => ProfilePage(),
              '/home': (context) => const MyHomePage(),
              '/demo-screens': (context) => const DemoScreens(),
              '/chat': (context) => const ChatAI(),
              '/generate-exam': (context) => const GenerateExamScreen(),
              '/view-exam': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                
                // if (args is List<ExamQuestionModel>) {
                //   return ExamPreviewScreen(examQuestions: args);
                // }
                
                return const ExamPreviewScreen();
              },
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('🏠 AuthWrapper - State: ${state.runtimeType}');

        // ✅ HydratedBloc tự động restore state
        if (state is AuthLoggedInState) {
          print('✅ User logged in, showing profile');
          return MyHomePage(); // Hoặc MainNavigator với bottom nav
        }

        if (state is AuthLoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        print('🔐 User not logged in, showing login');
        return LoginPage();
      },
    );
  }
}
