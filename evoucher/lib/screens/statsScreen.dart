// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'package:evoucher/components/statComponent.dart';
// ignore: unused_import
import 'package:evoucher/consts/colors.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // amount controller
  TextEditingController amountController = TextEditingController();
  // get device width
  double get deviceWidth => MediaQuery.of(context).size.width;
  // stats data
  Map<String, dynamic> createdData = {};
  Map<String, dynamic> broadcastedData = {};
  Map<String, dynamic> redeemedData = {};
  // balance
  double balance = 0;

  // firstname
  String firstName = "";

  // flags
  bool isReloading = false;

  // credit user's wallet
  Future<int> credit_wallet(amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.creditWallet);
    var response = await http.post(url, headers: {
      // "Content-Type": "application/json",
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "amount": amount.toString(),
    });
    if (response.statusCode == 200) {
      print("Wallet Funded");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return 200;
  }

  // get stats from the api
  Future<void> getStats(bool reload) async {
    if (reload == true) {
      setState(() {
        isReloading = true;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? fullname = prefs.getString('fullname');
    List<String> nameParts = fullname!.split(" ");
    firstName = nameParts[0];

    var url = Uri.parse(APIEndpoints.stats);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token ${token.toString()}",
      },
    );

    if (response.statusCode == 200) {
      print("Stats Fetched Successfully");
      var data = jsonDecode(response.body)["stats"];
      setState(() {
        createdData = data["created"];
        broadcastedData = data["broadcasted"];
        redeemedData = data["redeemed"];
        balance = data["balance"];
      });
      print(createdData);
      print(broadcastedData);
      print(redeemedData);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // show success dialog
  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Wallet Credited!"),
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

  // show dialog to credit account
  Future<void> _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Funds"),
            content: SizedBox(
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter Amount"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Enter Card Number"),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card Number',
                    ),
                  ),
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
                  // credit wallet
                  var res =
                      await credit_wallet(double.parse(amountController.text));
                  if (res == 200) {
                    print("Wallet Funded");
                    Navigator.of(context).pop();
                    _showSuccessDialog();
                    return;
                  } else {
                    print("Wallet Funding Failed");
                    Navigator.of(context).pop();
                    return;
                  }
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
  }

  @override
  initState() {
    super.initState();
    getStats(false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            height: deviceHeight * 0.2,
            width: double.infinity,
            color: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(
                  "Hi $firstName",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome to eVoucher",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "\$ $balance",
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      // const Spacer(),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor:
                            //     const Color.fromARGB(255, 0x32, 0xB7, 0x68),
                            backgroundColor:
                                const Color.fromRGBO(255, 255, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // display an alert dialog with two textinput field to add funds
                            _showDialog();
                          },
                          child: const Text(
                            "+ Add Funds",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.7,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Created Vouchers",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0x32, 0xB7, 0x68),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            getStats(true);
                            // Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                content: Text("Stats Refreshed"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh_sharp),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StatCard(
                      title: "ALL VOUCHERS",
                      total: createdData["all"].toString(),
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatCard(
                            title: "SILVER",
                            total: createdData["silver"].toString(),
                            icon: Icons.accessibility,
                          ),
                          StatCard(
                            title: "GOLD",
                            total: createdData["gold"].toString(),
                            icon: Icons.gpp_good_outlined,
                          ),
                        ],
                      ),
                    ),
                    StatCard(
                      title: "DIAMOND",
                      total: createdData["diamond"].toString(),
                      icon: Icons.diamond_outlined,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Broadcated Vouchers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0x32, 0xB7, 0x68),
                      ),
                    ),
                    StatCard(
                      title: "ALL VOUCHERS",
                      total: broadcastedData["all"].toString(),
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "SILVER",
                      total: broadcastedData["silver"].toString(),
                      icon: Icons.accessibility,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "GOLD",
                      total: broadcastedData["gold"].toString(),
                      icon: Icons.gpp_good_outlined,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "DIAMOND",
                      total: broadcastedData["diamond"].toString(),
                      icon: Icons.diamond_outlined,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Redeemed Vouchers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0x32, 0xB7, 0x68),
                      ),
                    ),
                    StatCard(
                      title: "ALL VOUCHERS",
                      total: redeemedData["all"].toString(),
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "SILVER",
                      total: redeemedData["silver"].toString(),
                      icon: Icons.accessibility,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "GOLD",
                      total: redeemedData["gold"].toString(),
                      icon: Icons.gpp_good_outlined,
                      fullWidth: true,
                    ),
                    StatCard(
                      title: "DIAMOND",
                      total: redeemedData["diamond"].toString(),
                      icon: Icons.diamond_outlined,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
