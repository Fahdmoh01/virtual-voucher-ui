// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:evoucher/screens/login_signup.dart';
import 'package:flutter/material.dart';
// import http package and convert dart file

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/evoucher-logo.png',
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Welcome to eVoucher",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  "Please login or signup to enjoy our services",
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 255, 0, 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // _showBottomSheet(context, 1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginSignUpScreen(indx: 1),
                      ),
                    );
                  },
                  child: const Text("Sign Up", style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: const Color.fromARGB(200, 255, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // _showBottomSheet(context, 0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginSignUpScreen(indx: 0),
                      ),
                    );
                  },
                  child: const Text("Login", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
