// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:evoucher/screens/dynamic/app_user/app_user_home_screen.dart';
import 'package:evoucher/screens/dynamic/restaurant/restaurant_home_screen.dart';
import 'package:evoucher/screens/statsScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userRole = "APP_USER";
  TextEditingController EventIdController = TextEditingController();

  double get deviceWidth => MediaQuery.of(context).size.width;

  // credit user's wallet
  Future<int> joinEvent(eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.joinEvent);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "event_id": eventId,
    });
    if (response.statusCode == 200) {
      print("Event Joined");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return 200;
  }

  // show success dialog
  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Event Joined!"),
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

  // show join event dialog
  Future<void> _showJoinEventDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Join Event"),
            content: SizedBox(
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter ID"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: EventIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Event ID',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  var res = await joinEvent(EventIdController.text);
                  if (res == 200) {
                    _showSuccessDialog();
                    return;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Couldn't Join Event"),
                      ),
                    );
                    return;
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
  }

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

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.deepPurple,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        elevation: 0,
        title: const Text(
          'eVoucher',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: userRole == "APP_USER"
          ? const AppUserStatsScreen()
          : userRole == "ORGANIZER"
              ? const StatsScreen()
              : const RestaurantUserStatsScreen(),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 0)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 0,
                )
              : const RestaurantNavBar(selectedIndex: 0),
      floatingActionButton: userRole == "APP_USER"
          ? FloatingActionButton(
              backgroundColor: Colors.green[50],
              child: const Icon(
                Icons.join_full,
                color: Colors.black,
              ),
              onPressed: () {
                _showJoinEventDialog();
              },
            )
          : userRole == "ORGANIZER"
              ? null
              : null,
    );
  }
}
