import 'package:evoucher/screens/homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // BOTTOM SHEET
  Future<void> _showBottomSheet(BuildContext context, int indx) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          initialIndex: indx,
          length: 2,
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TabBar(
                    tabs: [
                      Tab(text: "Login"),
                      Tab(text: "Signup"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Login tab content
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 35),
                                const Text(
                                  "By signing in, you agree to our Terms of Use and Privacy Policy",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Signup tab content
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  "Signup",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Fullname",
                                    hintText: "Enter your fullname",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 15),
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    hintText: "Confirm your password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: "User Role",
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "ORGANIZER",
                                      child: Text("Organizer"),
                                    ),
                                    DropdownMenuItem(
                                      value: "RESTAURANT",
                                      child: Text("Restaurant"),
                                    ),
                                    DropdownMenuItem(
                                      value: "APP_USER",
                                      child: Text("App User"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    // Handle dropdown value change
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "By signing up, you agree to our Terms of Use and Privacy Policy",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Signup",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                  onPressed: () {
                    _showBottomSheet(context, 1);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 158, 242, 160)),
                  ),
                  child: const Text("Sign Up", style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _showBottomSheet(context, 0);
                  },
                  style: const ButtonStyle(),
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
