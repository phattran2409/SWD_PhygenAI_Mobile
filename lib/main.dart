import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phygen/core/services/token_storage_service.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';
import 'package:phygen/features/Auth/data/remote/auth_remote_data_source.dart';
import 'package:phygen/features/Auth/data/remote/google_signIn.dart';
import 'package:phygen/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:phygen/features/Auth/data/repositories/google_singIn_impl.dart';
import 'package:phygen/features/Auth/domain/usecases/login_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/google_signIn_usecase.dart';
import 'package:phygen/features/Auth/domain/usecases/signup_usecase.dart';
import 'package:phygen/features/Auth/presentation/pages/signupPage.dart';

import 'features/Auth/bloc/auth_bloc.dart';
import 'features/Auth/bloc/auth_event.dart';
import 'features/Auth/bloc/auth_state.dart';
import 'features/Auth/presentation/pages/loginPages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'features/upload/presentation/upload_screen.dart';

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
            loginUsecase: LoginUsecase(
              authRepository: AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  firebaseAuth: FirebaseAuth.instance,
                ),
                tokenStorageService: TokenStorageService(),
              ),
            ),
            signUpUseCase: SignUpUseCase(
              authRepository: AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  firebaseAuth: FirebaseAuth.instance,
                ),
                tokenStorageService: TokenStorageService(),
              ),
            ),  
            googleSignInUsecase: GoogleSignInUsecase(
              googleSignInRepository: GoogleSignInImpl(
                tokenStorageService: TokenStorageService(),
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
          '/upload': (context) => const UploadScreen(),
        },  
        debugShowCheckedModeBanner: false,  
         
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: Colors.black),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 20.0, top: 10),

              iconSize: 40,
            ),
            tooltip: 'Login Here',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
         
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Phygen',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here are your sites',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/upload');
                      },
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.auto_awesome, color: Colors.green, size: 36),
                            SizedBox(height: 8),
                            Text('Upload ', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Add Your File Here', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.grid_view, color: Colors.grey, size: 36),
                          SizedBox(height: 8),
                          Text('Content', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Manage Your Content', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
               const Text(
                'Your created Exam',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                
              ),
          const SizedBox(height: 16),
              Container(
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSiteTile(
                      context,
                      icon: Icons.verified,
                      iconBg: const Color(0xFFFFF7D6),
                      title: 'Fintech Website',
                      subtitle: 'Free • Unpublished',
                    ),
                    const Divider(height: 1),
                    _buildSiteTile(
                      context,
                      icon: Icons.verified,
                      iconBg: const Color(0xFFFFE6E6),
                      title: 'E-commerce Website',
                      subtitle: 'Free • Unpublished',
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyCircleNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/upload');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildSiteTile(BuildContext context, {required IconData icon, required Color iconBg, required String title, required String subtitle}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.more_horiz),
      onTap: () {},
    );
  }
}
