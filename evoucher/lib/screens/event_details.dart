// ignore_for_file: sized_box_for_whitespace, avoid_print, use_build_context_synchronously

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:evoucher/screens/items_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;

class EventDetailScreen extends StatefulWidget {
  final String eventName;
  final String eventID;
  final String eventDate;
  final String eventCreator;
  final String eventCreatorEmail;
  const EventDetailScreen({
    super.key,
    required this.eventName,
    required this.eventID,
    required this.eventDate,
    required this.eventCreator,
    this.eventCreatorEmail = "eventcreator@gmail.com",
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String userRole = "APP_USER";

  get deviceWidth => MediaQuery.of(context).size.width;

  // delete event
  Future<int> deleteEvent(eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.events);
    var response = await http.delete(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "event_id": eventId,
    });
    if (response.statusCode == 200) {
      print("Event Deleted");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
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

  // show dialog
  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Event Deleted!"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Event Name"),
                  Text(
                    widget.eventName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Date"),
                  Text(
                    widget.eventDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Creator Name"),
                  Text(
                    widget.eventCreator,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Creator Email"),
                  Text(
                    widget.eventCreatorEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          var res = await deleteEvent(widget.eventID);
          if (res == 200) {
            _showSuccessDialog();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemsListScreen(),
              ),
            );
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to delete event"),
              ),
            );
            return;
          }
        },
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 2)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 2,
                )
              : const RestaurantNavBar(selectedIndex: 2),
    );
  }
}
