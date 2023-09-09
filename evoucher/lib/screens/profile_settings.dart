// ignore_for_file: sized_box_for_whitespace, avoid_print, use_build_context_synchronously, prefer_final_fields

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();

  // user info
  String _userEmail = "mohammedfahd@gmail.com";
  String _userFullname = "Mohammed Fahd";

  String userRole = "APP_USER";

  double get deviceWidth => MediaQuery.of(context).size.width;
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

      _emailController.text = _userEmail;
      _fullnameController.text = _userFullname;
    });
  }

  // add events
  Future<int> ChangeProfile(fullname, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.changeProfile);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "fullname": fullname,
      "email": email,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var userData = data["user"];
      print("Profile Updated Successfully");
      await prefs.setString("fullname", userData["fullname"]);
      await prefs.setString("email", userData["email"]);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
  }

  // show dialog
  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Profile Updated!"),
          content: SizedBox(
            height: 300,
            width: deviceWidth * 0.8,
            child: Column(
              children: [
                Image.asset("assets/images/success-check.png"),
              ],
            ),
          ),
        );
      },
    );
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
        title: const Text("Profile Settings"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Image.asset('assets/images/profile.png'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _userFullname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Center(
                child: Text(
                  _userEmail,
                ),
              ),
              Text(
                userRole,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Fullname"),
                  TextField(
                    controller: _fullnameController,
                  ),
                  const SizedBox(height: 30),
                  const Text("Email"),
                  TextField(
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(120, 0, 255, 0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Save Settings"),
                  onPressed: () async {
                    print("Email: ${_emailController.text}");
                    print("Fullname: ${_fullnameController.text}");
                    var res = await ChangeProfile(
                        _fullnameController.text, _emailController.text);
                    if (res == 200) {
                      _showSuccessDialog();
                      return;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Couldn't Update Profile"),
                        ),
                      );
                      return;
                    }
                  },
                ),
              ),
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
