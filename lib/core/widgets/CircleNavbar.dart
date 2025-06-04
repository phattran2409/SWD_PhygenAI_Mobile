import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCircleNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const MyCircleNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleNavBar(
      activeIndex: selectedIndex,
      activeIcons: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.upload_file, color: Colors.white),
        Icon(Icons.person, color: Colors.white),
      ],
      inactiveIcons: const [
        Icon(Icons.home_outlined , color: Colors.black),
        Icon(Icons.upload_file_outlined, color: Colors.black),
        Icon(Icons.person_outlined, color: Colors.black ),
      ],
      color: const Color.fromARGB(255, 172, 172, 172),
      height: 60,
      circleWidth: 60,
      onTap: onItemSelected,
      padding: const EdgeInsets.all(8.0),
      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
      ),
    );
  }
}
