import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:evoucher/screens/add_item.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:evoucher/screens/items_list.dart';
import 'package:evoucher/screens/redeem_voucher.dart';
import 'package:evoucher/screens/profile.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  CustomBottomNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
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
          child: const Icon(Icons.add, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
          },
        ),
        InkWell(
          child: const Icon(Icons.list, size: 30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemsListScreen()),
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
