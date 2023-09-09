// ignore_for_file: avoid_print

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  // user info
  String _userEmail = "mohammedfahd@gmail.com";
  String _userFullname = "Mohammed Fahd";

  String userRole = "APP_USER";
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

  void getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("email");
    final String? fullname = prefs.getString("fullname");
    setState(() {
      _userEmail = email.toString();
      _userFullname = fullname.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserRole();
    getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                child: Image.asset('assets/images/profile.png'),
              ),
              const SizedBox(height: 10),
              Text(
                _userFullname,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _userEmail,
              ),
              Text(
                userRole,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Column(
                children: [
                  Image.asset(
                    'assets/images/warning.png',
                    height: 100,
                  ),
                  const Text("This action cannot be reverted!"),
                  const Text(
                    "All your data will be deleted!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
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
                    "Delete Account",
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
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 2)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 3,
                )
              : const RestaurantNavBar(selectedIndex: 2),
    );
  }
}
