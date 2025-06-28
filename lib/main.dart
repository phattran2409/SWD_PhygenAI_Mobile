import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phygen/core/di/bloc_provider.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Auth/presentation/pages/signupPage.dart';
import 'package:phygen/features/Home/homePage.dart';
import 'package:phygen/features/Profile/presentation/profilePages.dart';
import 'features/Auth/presentation/pages/loginPages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/Exam/presentation/screens/upload/upload_screen.dart';
import 'features/Exam/presentation/screens/demo_screens.dart';
import 'core/di/injection_container.dart' as di;


void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();

    // ✅ 1. Initialize HydratedStorage TRƯỚC KHI tạo bất kỳ Bloc nào
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  final storageDir = await getApplicationDocumentsDirectory();
  print('📁 HydratedStorage path: ${storageDir.path}');
  
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: storageDir,
  );
  
  print('💾 HydratedStorage initialized: ${HydratedBloc.storage != null}');
  
  await Firebase.initializeApp();

  await di.init(); // Initialize dependency injection

  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
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
    print('🔄 ${bloc.runtimeType}: ${transition.currentState.runtimeType} → ${transition.nextState.runtimeType}');
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
          '/profile': (context) =>  ProfilePage(),
          '/home': (context) => const MyHomePage(),
          '/demo-screens': (context) => const DemoScreens(),
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
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        print('🔐 User not logged in, showing login');
        return LoginPage();
      },
    );
  }
}