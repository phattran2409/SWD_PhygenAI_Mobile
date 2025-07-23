import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/widgets/BackgroundWave.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';

import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_event.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Auth/domain/entities/user.dart';
import 'package:phygen/features/Home/homePage.dart';
import 'package:phygen/features/Exam/presentation/screens/upload/upload_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryColor = Color(0xFF4A4A4A); // Medium gray
  static const Color secondaryColor = Color(0xFF6B6B6B); // Light gray
  static const Color accentColor = Color(0xFF8C8C8C); // Lighter gray
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Off-white background
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color(0xFF2C2C2C); // Dark gray for text
  static const Color inputBackgroundColor = Color(
    0xFFF0F0F0,
  ); // Light gray for input
  final List<Widget> _pages = [
    const MyHomePage(),
    const UploadScreen(),
    ProfilePage(),
  ];
  int _selectedIndex = 2; // Default to ProfilePage
  @override
  void initState() {
    super.initState();

    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final authBloc = context.read<AuthBloc>();
    final currentState = authBloc.state;

    print('📱 ProfilePage - Current auth state: ${currentState.runtimeType}');

    // ✅ Nếu user chưa login, redirect về login page
    if (currentState is! AuthLoggedInState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: BlocConsumer<AuthBloc, AuthState>(
  //       listener: (context, state) {
  //         // ✅ Handle state changes
  //         if (state is AuthErrorState) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(state.message),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         }

  //         if (state is AuthInitialState) {
  //           Navigator.pushReplacementNamed(context, '/login');
  //         }
  //       },
  //       builder: (context, state) {
  //         // ✅ Loading state
  //         if (state is AuthLoadingState) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         // ✅ User logged in - show profile
  //         if (state is AuthLoggedInState) {
  //           return Material(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                 // Header with background image
  //                 Container(
  //                   height: 200.h,
  //                   decoration: BoxDecoration(
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.5),
  //                         blurRadius: 10,
  //                         offset: Offset(0, 2),
  //                       ),
  //                     ],
  //                     image: DecorationImage(
  //                       image: AssetImage('assets/images/default_header.jpg'),
  //                       fit: BoxFit.cover,

  //                     ),
  //                     borderRadius: BorderRadius.only(
  //                       bottomLeft: Radius.circular(20.r),
  //                       bottomRight: Radius.circular(20.r),
  //                     ),
  //                   ),
  //                 ),

  //                 // Profile Avatar
  //                 Container(
  //                   transform: Matrix4.translationValues(0, -50.h, 0),
  //                   color: const Color.fromARGB(255, 151, 36, 36),

  //                   child: CircleAvatar(
  //                     radius: 50.r,
  //                     backgroundColor: Colors.white,
  //                     child: CircleAvatar(
  //                       radius: 45.r,
  //                       backgroundImage: AssetImage(
  //                         'assets/images/default_avatar.jpg',
  //                       ),
  //                       onBackgroundImageError: (exception, stackTrace) {
  //                         print('Avatar image error: $exception');
  //                       },
  //                     ),
  //                   ),
  //                 ),

  //                Container(
  //                   transform: Matrix4.translationValues(0, -50.h, 0),
  //                   padding: EdgeInsets.symmetric(horizontal: 24.w),
  //                   child : Column(
  //                     children: [
  //                       SizedBox(height: 10.h),
  //                       Text(
  //                         state.user.username ?? 'User Name',
  //                         style: TextStyle(
  //                           fontSize: 20.sp,
  //                           fontWeight: FontWeight.bold,
  //                           color: textColor,
  //                         ),
  //                       ),
  //                       SizedBox(height: 5.h),
  //                       Text(
  //                         state.user.email ?? 'User Email',
  //                         style: TextStyle(
  //                           fontSize: 16.sp,
  //                           color: secondaryColor,
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                 ),

  //                 // SizedBox(height: 30.h),

  //                 // Profile Sections
  //                 _buildSection(
  //                   title: 'Account Settings',
  //                   icon: Icons.settings_outlined,
  //                   items: [
  //                     _buildMenuItem(
  //                       icon: Icons.person_outline,
  //                       title: 'Edit Profile',
  //                       onTap: () {},
  //                     ),
  //                     _buildMenuItem(
  //                       icon: Icons.lock_outline,
  //                       title: 'Change Password',
  //                       onTap: () {},
  //                     ),
  //                     _buildMenuItem(
  //                       icon: Icons.language,
  //                       title: 'Language',
  //                       subtitle: 'English',
  //                       onTap: () {},
  //                     ),
  //                   ],
  //                 ),

  //                 _buildSection(
  //                   title: 'Notifications',
  //                   icon: Icons.notifications_outlined,
  //                   items: [
  //                     _buildMenuItem(
  //                       icon: Icons.notifications_active,
  //                       title: 'Push Notifications',
  //                       subtitle: 'Enabled',
  //                       onTap: () {},
  //                     ),
  //                     _buildMenuItem(
  //                       icon: Icons.email_outlined,
  //                       title: 'Email Notifications',
  //                       subtitle: 'Enabled',
  //                       onTap: () {},
  //                     ),
  //                   ],
  //                 ),

  //                 _buildSection(
  //                   title: 'Exam Management',
  //                   icon: Icons.assignment_outlined,
  //                   items: [
  //                     _buildMenuItem(
  //                       icon: Icons.quiz,
  //                       title: 'My Exams',
  //                       subtitle: 'View all created exams',
  //                       onTap: () {},
  //                     ),
  //                     _buildMenuItem(
  //                       icon: Icons.history,
  //                       title: 'Exam History',
  //                       subtitle: 'View past results',
  //                       onTap: () {},
  //                     ),
  //                     _buildMenuItem(
  //                       icon: Icons.analytics_outlined,
  //                       title: 'Statistics',
  //                       subtitle: 'View performance metrics',
  //                       onTap: () {},
  //                     ),
  //                   ],
  //                 ),

  //                 SizedBox(height: 20.h),

  //                 // Sign Out Button
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 24.w),
  //                   child: SizedBox(
  //                     width: double.infinity,
  //                     height: 50.h,
  //                     child: ElevatedButton.icon(
  //                       onPressed: () => _handleSignOut(),
  //                       icon: const Icon(Icons.logout, color: Colors.white),
  //                       label: Text(
  //                         'Sign Out',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18.sp,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: primaryColor,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(25.r),
  //                         ),
  //                         elevation: 5,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 40.h),

  //               ],
  //               ),
  //             ),
  //           );
  //         }

  //         // ✅ Not logged in or other states
  //         return Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.person_off, size: 80.r, color: secondaryColor),
  //               SizedBox(height: 16.h),
  //               Text(
  //                 'Please log in to view profile',
  //                 style: TextStyle(fontSize: 18.sp, color: textColor),
  //               ),
  //               SizedBox(height: 20.h),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pushReplacementNamed(context, '/login');
  //                 },
  //                 child: Text('Go to Login'),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: primaryColor,
  //                   foregroundColor: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //     backgroundColor: backgroundColor,
  //     bottomNavigationBar: _buildBottomNav(
  //       currentIndex: _selectedIndex,
  //       onTap: (index) {
  //         setState(() {
  //           _selectedIndex = index;
  //         });
  //         // Navigate to the selected page
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => _pages[index]),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WaveBackground(
      colors: [
        const Color.fromARGB(255, 206, 210, 230),
        const Color.fromARGB(255, 162, 158, 167),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState || state is AuthLoggedOutState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is AuthErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is AuthLoggedInState) {
              return _buildProfileScreen(state);
            }
            return Center(
              child: Text(
                'Please log in to view your profile',
                style: TextStyle(fontSize: 18.sp, color: textColor),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileScreen(AuthLoggedInState state) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header with background image
                    Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/images/default_header.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                    ),

                    // Profile Avatar
                    Container(
                      transform: Matrix4.translationValues(0, -50.h, 0),
                    
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45.r,
                          backgroundImage: AssetImage(
                            'assets/images/default_avatar.jpg',
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            print('Avatar image error: $exception');
                          },
                        ),
                      ),
                    ),

                    // User Info
                    Container(
                      transform: Matrix4.translationValues(0, -50.h, 0),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            state.user.username ?? 'User Name',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            state.user.email ?? 'User Email',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile Sections
                    _buildSection(
                      title: 'Account Settings',
                      icon: Icons.settings_outlined,
                      items: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.language,
                          title: 'Change Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                      ],
                    ),
                    _buildSection(
                      title: 'App Settings',
                      icon: Icons.apps,
                      items: [
                        _buildMenuItem(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.privacy_tip,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleSignOut(),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height: 40.h)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(currentIndex: _selectedIndex, onTap:  (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Navigate to the selected page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _pages[index]),
        );
      }),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 24.w),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        ...items,
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: primaryColor, size: 20.w),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 14.sp, color: secondaryColor),
                )
                : null,
        trailing: Icon(Icons.arrow_forward_ios, color: accentColor, size: 16.w),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }

  Widget _buildBottomNav({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: MyCircleNavbar(selectedIndex: currentIndex, onItemSelected: onTap),
    );
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: const Color.fromARGB(255, 205, 41, 41)),
          ),
          backgroundColor: cardColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: secondaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // ✅ Dispatch logout event to AuthBloc
                context.read<AuthBloc>().add(AuthLogoutEvent());
                // Note: Navigation sẽ được handle bởi BlocListener
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 13, 13),
                foregroundColor: Colors.white,
              ),
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
