import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Define color constants
  static const Color primaryColor = Color(0xFF4A4A4A); // Medium gray
  static const Color secondaryColor = Color(0xFF6B6B6B); // Light gray
  static const Color accentColor = Color(0xFF8C8C8C); // Lighter gray
  static const Color backgroundColor = Color(0xFFF5F5F5); // Off-white background
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color(0xFF2C2C2C); // Dark gray for text
  static const Color inputBackgroundColor = Color(0xFFF0F0F0); // Light gray for inputs
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers
  WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures the controllers are initialized after the first frame
      _checkAuthStatus();
    });
  }
  void _checkAuthStatus() {
  final authBloc = context.read<AuthBloc>();
  final currentState = authBloc.state; // ❌ Lúc này có thể chưa restore xong
  
  // Nếu HydratedBloc chưa restore state từ storage
  // currentState vẫn là AuthInitialState
  if (currentState is AuthLoggedInState) {
    // ❌ Redirect về login ngay cả khi user đã login
    Navigator.pushReplacementNamed(context, '/profile');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                
                content: Text('Login successful!'),
                backgroundColor: Colors.green,
              
              ),
            );
            Navigator.pushReplacementNamed(context, '/home');
          }

        
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5F5F5), // Light gray
                  Color(0xFFE8E8E8), // Lighter gray
                  Color(0xFFDCDCDC), // Even lighter gray
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      // Back button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Main content card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'TO YOUR ACCOUNT',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: textColor.withOpacity(0.7),
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            
                            // Email field
                            Container(
                              decoration: BoxDecoration(
                                color: inputBackgroundColor,
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'someone@gmail.com',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 16.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey.withOpacity(0.5),
                                    size: 24.w,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            
                            // Password field
                            Container(
                              decoration: BoxDecoration(
                                color: inputBackgroundColor,
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: '••••••••••••',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 16.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey.withOpacity(0.5),
                                    size: 24.w,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey.withOpacity(0.5),
                                      size: 24.w,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            
                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password logic
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            
                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 55.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_validateForm()) {
                                    context.read<AuthBloc>().add(
                                          AuthLoginEvent(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                          ),
                                        );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            
                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            
                            // Google sign in button
                            SizedBox(
                              width: double.infinity,
                              height: 55.h,
                              child: OutlinedButton.icon(
                                icon: Image.asset(
                                  'assets/images/google.png',
                                  height: 24.h,
                                ),
                                label: Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey[400]!,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                        AuthGoogleSignInEvent(),
                                      );
                                },
                              ),
                            ),
                            SizedBox(height: 24.h),
                            
                            // Sign up option
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _validateForm() {
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
