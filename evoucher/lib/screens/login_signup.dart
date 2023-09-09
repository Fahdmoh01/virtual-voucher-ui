// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:evoucher/network/api_endpoints.dart';
import 'package:evoucher/screens/homescreen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignUpScreen extends StatelessWidget {
  final int indx;
  const LoginSignUpScreen({Key? key, required this.indx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(1, 116, 223, 1),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Body(indx: indx),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final int indx;
  const Body({super.key, required this.indx});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoginLoading = false;
  bool isSignupLoading = false;
  double get deviceWidth => MediaQuery.of(context).size.width;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailSignupController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordSignupController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String role = "APP_USER";
  bool invalidEmailPassword = false;

  Future<int> _login(email, password) async {
    // start loading
    setState(() {
      isLoginLoading = true;
    });

    // initialize shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Make API call
      var url = Uri.parse(APIEndpoints.login);
      var response = await http.post(
        url,
        body: {
          "username": _emailController.text,
          "password": _passwordController.text,
        },
      );

      // stop loading
      setState(() {
        isLoginLoading = false;
      });

      if (response.statusCode == 200) {
        // Login successful
        print("Login successful");
        var data = jsonDecode(response.body);
        var userData = data["user"];
        var token = data["token"];
        print(userData);
        print(token);
        // Save token and user info
        await prefs.setString("token", data["token"]);
        await prefs.setString("fullname", userData["fullname"]);
        await prefs.setString("email", userData["email"]);
        await prefs.setString("role", userData["role"]);
        print(response.statusCode);
        return response.statusCode;
      } else {
        // Login failed
        print("Login failed");
        print(response.statusCode);
        print(response.reasonPhrase);
        return response.statusCode;
      }
    } catch (e) {
      // Handle exceptions by displaying a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
        ),
      );

      // Stop loading
      setState(() {
        isLoginLoading = false;
      });

      // Return an error code or handle it as needed
      return -1; // You can return a custom error code or value
    }
  }

  // Make API call to login
  // Future<int> _login(email, passowrd) async {
  //   // start loading
  //   setState(() {
  //     isLoginLoading = true;
  //   });
  //   // initialize shared preferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Make API call
  //   var url = Uri.parse(APIEndpoints.login);
  //   var response = await http.post(
  //     url,
  //     body: {
  //       "username": _emailController.text,
  //       "password": _passwordController.text,
  //     },
  //   );

  //   // stop loading
  //   setState(() {
  //     isLoginLoading = false;
  //   });

  //   if (response.statusCode == 200) {
  //     // Login successful
  //     print("Login successful");
  //     var data = jsonDecode(response.body);
  //     var userData = data["user"];
  //     var token = data["token"];
  //     print(userData);
  //     print(token);
  //     // Save token and user info
  //     await prefs.setString("token", data["token"]);
  //     await prefs.setString("fullname", userData["fullname"]);
  //     await prefs.setString("email", userData["email"]);
  //     await prefs.setString("role", userData["role"]);
  //     print(response.statusCode);
  //     return response.statusCode;
  //   } else {
  //     // Login failed
  //     print("Login failed");
  //     print(response.statusCode);
  //     print(response.reasonPhrase);
  //     return response.statusCode;
  //   }
  // }

  // signup user
  Future<int> _signUpUser(fullname, email, passowrd, role) async {
    // start loading
    setState(() {
      isSignupLoading = true;
    });
    // initialize shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Make API call
    var url = Uri.parse(APIEndpoints.signup);
    var response = await http.post(
      url,
      body: {
        "fullname": fullname,
        "email": email,
        "password": passowrd,
        "role": role,
      },
    );
    // start loading
    setState(() {
      isSignupLoading = false;
    });

    if (response.statusCode == 201) {
      // User created
      print("User account created");
      var data = jsonDecode(response.body);
      var userData = data["user"];
      var token = data["token"];
      print(userData);
      print(token);
      // Save token and user info
      await prefs.setString("token", data["token"]);
      await prefs.setString("fullname", userData["fullname"]);
      await prefs.setString("email", userData["email"]);
      await prefs.setString("role", userData["role"]);
      print(response.statusCode);
      return response.statusCode;
    } else {
      // Login failed
      print("Login failed");
      print(response.statusCode);
      print(response.reasonPhrase);
      return response.statusCode;
    }
  }

  // show dialog
  Future<void> _showErrorDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Error"),
          content: SizedBox(
            height: 100,
            width: deviceWidth * 0.8,
            child: const Column(
              children: [
                Text(
                  "Invalid Email or Passowrd",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: Image.asset(
                'assets/images/evoucher-logo.png',
                height: 100,
              )),
            ),
          ),
          Container(
            height: screenSize.height * 0.75,
            width: screenSize.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: DefaultTabController(
              initialIndex: widget.indx,
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TabBar(
                    labelColor: Colors.black,
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
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
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
                                invalidEmailPassword
                                    ? const Text(
                                        "Invalid Email or Password",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var email = _emailController.text;
                                      var password = _passwordController.text;

                                      if (email.isEmpty || password.isEmpty) {
                                        setState(() {
                                          invalidEmailPassword = true;
                                        });
                                        // snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Invalid Email or Password"),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );

                                        return;
                                      }
                                      var res = await _login(email, password);
                                      if (res == 200) {
                                        // Login successful
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                        );
                                      } else {
                                        // Login failed
                                        setState(() {
                                          invalidEmailPassword = true;
                                        });
                                        _showErrorDialog();
                                      }
                                    },
                                    child: isLoginLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text(
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
                                TextField(
                                  controller: _fullnameController,
                                  decoration: const InputDecoration(
                                    labelText: "Fullname",
                                    hintText: "Enter your fullname",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _emailSignupController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    hintText: "Enter your email",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _passwordSignupController,
                                  decoration: const InputDecoration(
                                    labelText: "Password",
                                    hintText: "Enter your password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _confirmPasswordController,
                                  decoration: const InputDecoration(
                                    labelText: "Confirm Password",
                                    hintText: "Confirm your password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  value: role,
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
                                    setState(() {
                                      role = value!;
                                    });
                                    print("value changed to $value");
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "By signing up, you agree to our Terms of Use and Privacy Policy",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      String fullName =
                                          _fullnameController.text;
                                      String userEmail =
                                          _emailSignupController.text;
                                      String password1 =
                                          _passwordSignupController.text;
                                      String password2 =
                                          _confirmPasswordController.text;
                                      String userRole = role;
                                      if (password1 == password2) {
                                        var res = await _signUpUser(
                                            fullName,
                                            userEmail,
                                            password1,
                                            role = userRole);
                                        if (res == 201) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Couldn't Signup User"),
                                            ),
                                          );
                                          return;
                                        }
                                        return;
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Passwords Mismatch"),
                                          ),
                                        );
                                        return;
                                      }
                                    },
                                    child: isSignupLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text(
                                            "Signup",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 30),
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
        ],
      ),
    );
  }
}
