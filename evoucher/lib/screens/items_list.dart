// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable

import 'package:evoucher/components/event_item.dart';
import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/components/voucher_item.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsListScreen extends StatefulWidget {
  final int selectedIndex;
  const ItemsListScreen({super.key, this.selectedIndex = 0});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  List<dynamic> allEvents = [];
  List<dynamic> allVouchers = [];

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

  // get events
  Future<int> get_events() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.allEvents);
    var response = await http.get(url, headers: {
      "Authorization": "Token ${token.toString()}",
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var events = data["events"];
      setState(() {
        allEvents = events;
      });
      print(allEvents);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
  }

  // get vouchers
  Future<int> get_vouchers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.allVouchers);
    var response = await http.get(url, headers: {
      "Authorization": "Token ${token.toString()}",
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var vouchers = data["vouchers"];
      setState(() {
        allVouchers = vouchers;
      });
      print(allVouchers);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
  }

  @override
  void initState() {
    super.initState();
    get_events();
    get_vouchers();
    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events and Vouchers"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        elevation: 0,
      ),
      body: DefaultTabController(
        initialIndex: widget.selectedIndex,
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.deepPurple,
              labelColor: Colors.black,
              tabs: [
                Tab(text: "Events"),
                Tab(text: "Vouchers"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "All Events",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        for (var event in allEvents)
                          EventItemCard(
                            eventName: event["name"],
                            date: event["date"],
                            eventCreator: event["created_by"]["fullname"],
                            eventCreatorEmail: event["created_by"]["email"],
                            eventID: event["event_id"],
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "All Vouchers",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        for (var voucher in allVouchers)
                          VoucherItemCard(
                            eventName: voucher["event"]["name"],
                            eventId: voucher["event"]["event_id"],
                            voucherID: voucher["voucher_id"],
                            voucherAmount: double.parse(voucher["amount"]),
                            voucherCreator: voucher["event"]["created_by"]
                                ["fullname"],
                            voucherCreatorEmail: voucher["event"]["created_by"]
                                ["email"],
                            voucherDate: voucher["event"]["date"],
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
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
