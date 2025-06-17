import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:phygen/features/Auth/bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static const Color primaryColor = Color(0xFF4A4A4A); // Medium gray
  static const Color secondaryColor = Color(0xFF6B6B6B); // Light gray
  static const Color accentColor = Color(0xFF8C8C8C); // Lighter gray
  static const Color backgroundColor = Color(0xFFF5F5F5); // Off-white background
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textColor = Color(0xFF2C2C2C); // Dark gray for text
  static const Color inputBackgroundColor = Color(0xFFF0F0F0); // Light gray for inp
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/default_header.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
            Container(
              transform: Matrix4.translationValues(0, -50.h, 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: textColor.withOpacity(0.45),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50.r, // Adjusted radius for better fit
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                   // Replace with user's avatar
                ),
              ),
             ), // Adjust overlap height

            SizedBox(height: 60.h), // Space for avatar overlap
            // User Info Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // User Name
                    Text(
                      'Nguyen Van A', // Replace with user's name from state
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // User Email
                    Text(
                      'someone@gmail.com', // Replace with user's email from state
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: secondaryColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Other Info (example)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cake, color: secondaryColor, size: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          '01/01/2000', // Replace with user's birthday if available
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: secondaryColor, size: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          '+84 123 456 789', // Replace with user's phone if available
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),

            // Sign Out Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Dispatch sign out event
                    // context.read<AuthBloc>().add(AuthLogoutEvent());
                    Navigator.pushReplacementNamed(context, '/login');
                  },
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
            SizedBox(height: 40.h),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
