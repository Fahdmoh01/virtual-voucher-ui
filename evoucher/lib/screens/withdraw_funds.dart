// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;

class WithdrawFundScreen extends StatefulWidget {
  const WithdrawFundScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawFundScreenState createState() => _WithdrawFundScreenState();
}

class _WithdrawFundScreenState extends State<WithdrawFundScreen> {
  double get deviceWidth => MediaQuery.of(context).size.width;
  // amount controller
  TextEditingController amountController = TextEditingController();

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

  // credit user's wallet
  Future<int> debit_wallet(amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.debitWallet);
    var response = await http.post(url, headers: {
      // "Content-Type": "application/json",
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "amount": amount.toString(),
    });
    if (response.statusCode == 200) {
      print("Wallet Debited Successfully");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return 200;
  }

  // show dialog
  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Withdrawal Successful!"),
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
        title: const Text("Withdraw Funds"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Withdraw Funds",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          hintText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: "Account Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 165, 224, 167),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var res = await debit_wallet(
                              double.parse(amountController.text),
                            );
                            if (res == 200) {
                              print("Wallet Debited Successfully");
                              _showDialog();
                              return;
                            } else {
                              print("Wallet Debited Failed");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  content: Text("Wallet Debited Failed"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Text("Withdraw Funds"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 1)
          : userRole == "ORGANIZER"
              ? OrganazinerNavBar(
                  selectedIndex: 1,
                )
              : RestaurantNavBar(selectedIndex: 1),
    );
  }
}
