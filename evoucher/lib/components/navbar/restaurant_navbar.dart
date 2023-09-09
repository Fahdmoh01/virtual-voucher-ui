// ignore_for_file: avoid_print

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:evoucher/screens/redeem_voucher.dart';
import 'package:evoucher/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantNavBar extends StatefulWidget {
  final int selectedIndex;
  const RestaurantNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<RestaurantNavBar> createState() => _RestaurantNavBarState();
}

class _RestaurantNavBarState extends State<RestaurantNavBar> {
  String userRole = "APP_USER";
  List<Widget> navItems = [];

  // Get the user role from shared preferences
  Future<void> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleFromPrefs =
        prefs.getString('role'); // Use a different variable name
    print("Role Before setState(): $roleFromPrefs");
    setState(() {
      userRole = roleFromPrefs ?? "APP_USER"; // Set the class-level userRole
    });
    print("Role After setState(): $userRole");
  }

  // set the right nav items based on the user role

  @override
  void initState() {
    super.initState();
    getUserRole();
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
          child: const Icon(Icons.compare_arrows, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RedeemVoucherScreen()),
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
