import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phygen/core/widgets/BackgroundWave.dart';
import 'package:phygen/core/widgets/CircleNavbar.dart';
import 'package:phygen/features/Auth/bloc/auth_bloc.dart';
import 'package:phygen/features/Auth/bloc/auth_state.dart';
import 'package:phygen/features/Exam/presentation/screens/history_analyzed/history_analyzed_screen.dart';
import 'package:phygen/features/Exam/presentation/screens/saved_exam/saved_exams_screen.dart';
import 'package:phygen/features/Profile/presentation/profilePages.dart';
import 'package:phygen/features/Exam/presentation/screens/upload/upload_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [MyHomePage(), UploadScreen(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return WaveBackground(
      colors: [
        const Color.fromARGB(255, 206, 210, 230),
        const Color.fromARGB(255, 162, 158, 167),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ✅ Custom AppBar
              _buildCustomAppBar(),
              
              // ✅ Body
              Expanded(
                child: _buildBody(),
              ),
              
              // ✅ Bottom Navigation
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[index]),
            );
          },
        )
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoggedInState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.user.username}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Welcome back!',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 90, 90, 90),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }
                return const Text('Welcome!', 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, 
              color: Colors.black, size: 32),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Main content container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Phygen',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here you can create, manage and analyze your exams with ease.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  
                  // ✅ Action cards
                
                        _buildActionCard(
                          icon: Icons.auto_awesome,
                          iconColor: Colors.green,
                          backgroundColor: const Color(0xFFE6F7EC),
                          title: 'Upload',
                          subtitle: 'Add Your File Here',
                          onTap: () => Navigator.pushNamed(context, '/upload'),
                        ),
                    
                   
                  
                  const SizedBox(height: 16),
                  
                  // ✅ Demo button
                  _buildActionCard(
                    icon: Icons.phone_android,
                    iconColor: Colors.indigo,
                    backgroundColor: const Color(0xFFE8EAF6),
                    title: 'Demo Screens',
                    subtitle: 'View All Exam Screens',
                    onTap: () => Navigator.pushNamed(context, '/demo-screens'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // ✅ Exam section
                  const Text(
                    'Your created Exam',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.folder,
                          iconColor: Colors.purple,
                          backgroundColor: Colors.purple.withOpacity(0.05),
                          title: 'Saved Exam',
                          subtitle: 'View Your Saved Exam',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const SavedExamsScreen(),
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          icon: Icons.history,
                          iconColor: Colors.orange,
                          backgroundColor: Colors.orange.withOpacity(0.05),
                          title: 'History Analysis',
                          subtitle: 'View Your History',
                          onTap:  () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const HistoryAnalyzedScreen(),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 36),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

Widget _buildBottomNav({
    required int selectedIndex,
    required Function(int) onTap}) {
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
      child: MyCircleNavbar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
      ),
    );
  }

  Widget _buildSiteTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
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
