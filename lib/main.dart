import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/features/Auth/data/remote/auth_remote_data_source.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:phygen/features/Auth/data/repositories/google_singIn_impl.dart';
import 'package:phygen/features/Auth/domain/usecases/login_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/google_signIn_usecase.dart';
import 'package:phygen/features/Auth/presentation/pages/signupPage.dart';

import 'features/Auth/bloc/auth_bloc.dart';
import 'features/Auth/bloc/auth_event.dart';
import 'features/Auth/bloc/auth_state.dart';
import 'features/Auth/presentation/pages/loginPages.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUsecase: LoginUsecase(),
            googleSignInUsecase: GoogleSignInUsecase(
              googleSignInRepository: GoogleSignInImpl(
                googleSignInRemoteDataSource: GoogleSignInRemoteDataSourceImpl(),
              ),  
            ),
          ),
        ),
      ],
      child : ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
        title: 'Flutter Demo',
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
        home: const MyHomePage(title: 'Demo Home page clean architecture'),  
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(), 
        },  
      );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children : [ 
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Go to Login Page'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),  
      ),
    );
  }
}
