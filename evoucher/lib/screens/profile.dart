// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/components/profile_item.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:evoucher/screens/delete_account.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:evoucher/screens/login.dart';
import 'package:evoucher/screens/profile_settings.dart';
import 'package:evoucher/screens/withdraw_funds.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // user info
  String _userEmail = "mohammedfahd@gmail.com";
  String _userFullname = "Mohammed Fahd";
  String _userRole = "APP_USER";

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

  // logout user
  Future<int> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.logout);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token ${token.toString()}",
      },
    );
    print("Token is: $token");
    if (response.statusCode == 204) {
      print("Logout Successful");
      print("Status Code: ${response.statusCode}");
      prefs.remove("role");
      prefs.remove("token");
      prefs.remove("fullname");
      prefs.remove("email");
      return response.statusCode;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return response.statusCode;
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileInfo();
    getUserRole();
  }

  void getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString("email");
    final String? fullname = prefs.getString("fullname");
    final String role = prefs.getString("role").toString();
    setState(() {
      _userEmail = email.toString();
      _userFullname = fullname.toString();
      _userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
                _userRole,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              const PrilfeItem(
                title: "Profile Settings",
                NavScreen: ProfileSettingsScreen(),
              ),
              userRole == "RESTAURANT" || userRole == "ORGANIZER"
                  ? const PrilfeItem(
                      title: "Withdraw Funds",
                      NavScreen: WithdrawFundScreen(),
                    )
                  : const SizedBox(height: 0),
              userRole == "ORGANIZER"
                  ? const PrilfeItem(
                      title: "Add Funds",
                      NavScreen: HomeScreen(),
                    )
                  : const SizedBox(height: 0),
              const PrilfeItem(
                title: "Delete Account",
                NavScreen: DeleteAccountScreen(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    // _showDialog();
                    var res = await logout();
                    if (res == 204) {
                      print("Logout success");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      return;
                    } else {
                      print("Logout failed");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Logout Failed"),
                        ),
                      );
                    }
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
