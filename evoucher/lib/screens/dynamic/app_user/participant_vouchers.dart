// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable

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

class ParticipantVouchers extends StatefulWidget {
  final int selectedIndex;
  const ParticipantVouchers({super.key, this.selectedIndex = 0});

  @override
  State<ParticipantVouchers> createState() => _ParticipantVouchersState();
}

class _ParticipantVouchersState extends State<ParticipantVouchers> {
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

  // get vouchers
  Future<int> get_vouchers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.broadcastVoucher);
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
    get_vouchers();
    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vouchers Received"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const Text(
                  "Your Vouchers",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (var voucher in allVouchers)
                  VoucherItemCard(
                    eventName: voucher["voucher"]["event"]["name"],
                    eventId: voucher["voucher"]["event"]["event_id"],
                    voucherID: voucher["voucher"]["voucher_id"],
                    voucherAmount: double.parse(voucher["voucher"]["amount"]),
                    voucherCreator: voucher["voucher"]["event"]["created_by"]
                        ["fullname"],
                    voucherCreatorEmail: voucher["voucher"]["event"]
                        ["created_by"]["email"],
                    voucherDate: voucher["voucher"]["event"]["date"],
                  ),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 1)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 0,
                )
              : const RestaurantNavBar(selectedIndex: 0),
    );
  }
}
