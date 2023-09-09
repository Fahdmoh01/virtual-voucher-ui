// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedeemVoucherScreen extends StatefulWidget {
  const RedeemVoucherScreen({super.key});

  @override
  State<RedeemVoucherScreen> createState() => _RedeemVoucherScreenState();
}

class _RedeemVoucherScreenState extends State<RedeemVoucherScreen> {
  double get deviceWidth => MediaQuery.of(context).size.width;

  final TextEditingController _voucherCodeController = TextEditingController();
  final TextEditingController _redeemerEmailController =
      TextEditingController();

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

  // add events
  Future<int> redeemVoucher(voucherId, redeemerEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.redeemVouchers);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "voucher_id": voucherId.toString(),
      "redeemer_email": redeemerEmail.toString(),
    });
    if (response.statusCode == 200) {
      print("Voucher Redeemed!");
    } else {
      print("Error redeeming voucher ${response.statusCode}");
    }
    return response.statusCode;
  }

  // show dialog
  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Voucher Redeemed!"),
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
        title: const Text("Redeem Voucher"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Redeem Voucher",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0x32, 0xB7, 0x68),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _voucherCodeController,
                  decoration: const InputDecoration(
                    hintText: "Voucher Code",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _redeemerEmailController,
                  decoration: const InputDecoration(
                    hintText: "Redeemer Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                // button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      var res = await redeemVoucher(_voucherCodeController.text,
                          _redeemerEmailController.text);
                      if (res == 200) {
                        _showDialog();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error Redeeming Voucher"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 0x32, 0xB7, 0x68),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Redeem",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 0)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 0,
                )
              : const RestaurantNavBar(selectedIndex: 1),
    );
  }
}
