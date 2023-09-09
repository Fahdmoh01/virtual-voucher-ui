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

class VoucherDetailScreen extends StatefulWidget {
  final String voucherName;
  final String voucherID;
  final String eventID;
  final String voucherDate;
  final String voucherCreator;
  final String voucherCreatorEmail;
  final double voucherAmount;
  const VoucherDetailScreen({
    super.key,
    required this.voucherName,
    required this.voucherID,
    required this.voucherDate,
    required this.voucherCreator,
    this.eventID = '0',
    this.voucherAmount = 45.00,
    this.voucherCreatorEmail = "vouchercreator@gmail.com",
  });

  @override
  State<VoucherDetailScreen> createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen> {
  String userRole = "APP_USER";

  get deviceWidth => MediaQuery.of(context).size.width;

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

  // delete voucher
  Future<int> deleteVoucher(voucherId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.vouchers);
    var response = await http.delete(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "voucher_id": voucherId,
    });
    if (response.statusCode == 200) {
      print("Voucher Deleted");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
  }

  // delete voucher
  Future<int> broadcastVoucher(voucherId, eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.broadcastVoucher);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "voucher_id": voucherId,
      "event_id": eventId,
    });
    if (response.statusCode == 200) {
      print("Voucher Broadcasted");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return response.statusCode;
  }

  // show dialog
  Future<void> _showSuccessDialog(message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: Text(message),
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
        title: Text(widget.voucherName),
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
                  const Text("Voucher ID"),
                  Text(
                    widget.voucherID,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Event Name"),
                  Text(
                    widget.voucherName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Amount"),
                  Text(
                    widget.voucherAmount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Date"),
                  Text(
                    widget.voucherDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Creator Name"),
                  Text(
                    widget.voucherCreator,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Creator Email"),
                  Text(
                    widget.voucherCreatorEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: userRole == "APP_USER"
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () async {
                    var res = await broadcastVoucher(
                      widget.voucherID,
                      widget.eventID,
                    );
                    if (res == 200) {
                      _showSuccessDialog("Voucher Broadcasted!");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to broadcast voucher"),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () async {
                    var res = await deleteVoucher(widget.voucherID);
                    if (res == 200) {
                      _showSuccessDialog("Voucher Deleted!");
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
                          content: Text("Failed to delete voucher"),
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
              ],
            ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 1)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 2,
                )
              : const RestaurantNavBar(selectedIndex: 0),
    );
  }
}
