import 'package:evoucher/components/statComponent.dart';
// ignore: unused_import
import 'package:evoucher/consts/colors.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  double get deviceWidth => MediaQuery.of(context).size.width;
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
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter Amount"),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Card Number"),
                  SizedBox(height: 10),
                  TextField(
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
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessDialog();
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
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
                const Text(
                  "Hi Fahd",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome to eVoucher",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "\$ 1000.00",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor:
                            //     const Color.fromARGB(255, 0x32, 0xB7, 0x68),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // display an alert dialog with two textinput field to add funds
                            _showDialog();
                          },
                          child: const Text("+ Add Funds"),
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
                            onPressed: () {},
                            icon: const Icon(Icons.refresh_sharp)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const StatCard(
                      title: "ALL VOUCHERS",
                      total: '134',
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          title: "SILVER",
                          total: '23',
                          icon: Icons.accessibility,
                        ),
                        StatCard(
                          title: "GOLD",
                          total: '32',
                          icon: Icons.gpp_good_outlined,
                        ),
                      ],
                    ),
                    const StatCard(
                      title: "DIAMOND",
                      total: '45',
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
                    const StatCard(
                      title: "ALL VOUCHERS",
                      total: '134',
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "SILVER",
                      total: '134',
                      icon: Icons.accessibility,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "GOLD",
                      total: '134',
                      icon: Icons.gpp_good_outlined,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "DIAMOND",
                      total: '134',
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
                    const StatCard(
                      title: "ALL VOUCHERS",
                      total: '134',
                      icon: Icons.public_sharp,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "SILVER",
                      total: '134',
                      icon: Icons.accessibility,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "GOLD",
                      total: '134',
                      icon: Icons.gpp_good_outlined,
                      fullWidth: true,
                    ),
                    const StatCard(
                      title: "DIAMOND",
                      total: '134',
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
