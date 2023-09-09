// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_import, sized_box_for_whitespace

import 'package:evoucher/components/btmNavBar.dart';
import 'package:evoucher/components/navbar/app_user_navbar.dart';
import 'package:evoucher/components/navbar/organizer_nav_bar.dart';
import 'package:evoucher/components/navbar/restaurant_navbar.dart';
import 'package:evoucher/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import http package and convert dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  double get deviceWidth => MediaQuery.of(context).size.width;
  DateTime _selectedDate = DateTime.now();
  TextEditingController eventNameController = TextEditingController();

  // all events fetched
  List<dynamic> allEvents = [];
  String selectedEventID = "-1";
  String selectedVoucherType = "SILVER";
  TextEditingController amountController = TextEditingController();

  String userRole = "APP_USER";
  // Get the user role from shared preferences
  Future<void> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? roleFromPrefs =
        prefs.getString('role'); // Use a different variable name
    setState(() {
      userRole = roleFromPrefs ?? "APP_USER"; // Set the class-level userRole
    });
  }

  // add events
  Future<int> add_event(name, date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.events);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "name": name.toString(),
      "date": date.toString(),
    });
    if (response.statusCode == 201) {
    } else {}
    return response.statusCode;
  }

  // create voucher
  Future<int> create_voucher(amount, voucherType, event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    var url = Uri.parse(APIEndpoints.vouchers);
    var response = await http.post(url, headers: {
      "Authorization": "Token ${token.toString()}",
    }, body: {
      "amount": amount,
      "voucher_type": voucherType,
      "event_id": event,
    });
    if (response.statusCode == 201) {
    } else {}
    return response.statusCode;
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
    } else {}
    return response.statusCode;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2033),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // show dialog
  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Successfully Added!"),
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
    get_events();
    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
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
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Add Event", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: eventNameController,
                        decoration: const InputDecoration(
                          hintText: "Event Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Select Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${_selectedDate.toLocal()}'.split(' ')[0],
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
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
                            var res = await add_event(
                              eventNameController.text,
                              _selectedDate.toString(),
                            );
                            if (res == 201 || res == 200) {
                              await _showDialog();
                              return;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Couldn't add event"),
                                ),
                              );
                              return;
                            }
                          },
                          child: const Text("Add Event"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20, left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Add Voucher", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: const InputDecoration(
                          hintText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Voucher Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "SILVER",
                            child: Text("SILVER"),
                          ),
                          DropdownMenuItem(
                            value: "GOLD",
                            child: Text("GOLD"),
                          ),
                          DropdownMenuItem(
                            value: "DIAMOND",
                            child: Text("DIAMOND"),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle dropdown value change
                          setState(() {
                            selectedVoucherType = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Select Event",
                          border: OutlineInputBorder(),
                        ),
                        items: allEvents.map<DropdownMenuItem<String>>((event) {
                          return DropdownMenuItem<String>(
                            value: event["id"].toString(),
                            child: Text(event["name"]),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // Handle dropdown value change
                          setState(() {
                            selectedEventID = value.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Container(
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
                            var res = await create_voucher(
                              amountController.text,
                              selectedVoucherType,
                              selectedEventID,
                            );
                            if (res == 201) {
                              _showDialog();
                              return;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Couldn't Add Voucher"),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                ),
                              );
                            }
                          },
                          child: const Text("Add VOucher"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: userRole == "APP_USER"
          ? AppUserNavBar(selectedIndex: 0)
          : userRole == "ORGANIZER"
              ? const OrganazinerNavBar(
                  selectedIndex: 1,
                )
              : const RestaurantNavBar(selectedIndex: 0),
    );
  }
}
