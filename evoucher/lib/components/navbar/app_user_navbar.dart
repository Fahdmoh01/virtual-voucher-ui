import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evoucher/screens/dynamic/app_user/participant_vouchers.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:evoucher/screens/profile.dart';
import 'package:flutter/material.dart';

class AppUserNavBar extends StatefulWidget {
  final int selectedIndex;
  AppUserNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<AppUserNavBar> createState() => _AppUserNavBarState();
}

class _AppUserNavBarState extends State<AppUserNavBar> {
  // set the right nav items based on the user role

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.selectedIndex,
      height: 70,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.transparent,
      color: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
      items: [
        InkWell(
          child: const Icon(Icons.home, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        InkWell(
          child: const Icon(Icons.list, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParticipantVouchers(),
              ),
            );
          },
        ),
        InkWell(
          child: const Icon(Icons.perm_identity, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }
}
