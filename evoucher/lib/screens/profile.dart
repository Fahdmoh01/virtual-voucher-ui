import 'package:evoucher/components/btmNavBar.dart';
import 'package:evoucher/components/profile_item.dart';
import 'package:evoucher/screens/delete_account.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:evoucher/screens/login.dart';
import 'package:evoucher/screens/profile_settings.dart';
import 'package:evoucher/screens/withdraw_funds.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                child: Image.asset('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Fahd Mohammed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                "mohammedfahd@gmail.com",
              ),
              const SizedBox(height: 20),
              const PrilfeItem(
                title: "Profile Settings",
                NavScreen: ProfileSettingsScreen(),
              ),
              const PrilfeItem(
                title: "Cash Withdrawal",
                NavScreen: WithdrawFundScreen(),
              ),
              const PrilfeItem(
                title: "Add Funds",
                NavScreen: HomeScreen(),
              ),
              const PrilfeItem(
                title: "Delete Account",
                NavScreen: DeleteAccountScreen(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // _showDialog();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(200, 255, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 4),
    );
  }
}
