import 'package:evoucher/components/btmNavBar.dart';
import 'package:evoucher/components/event_item.dart';
import 'package:evoucher/components/voucher_item.dart';
import 'package:flutter/material.dart';

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Events and Vouchers"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0x32, 0xB7, 0x68),
        ),
        body: const DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.deepPurple,
                tabs: [
                  Tab(text: "Events"),
                  Tab(text: "Vouchers"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "All Events",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          EventItemCard(
                            eventName: "Graduation Night",
                            date: '12/12/2021',
                          ),
                          SizedBox(height: 8),
                          EventItemCard(
                            eventName: "Dinner and Awards",
                            date: '12/12/2021',
                          ),
                          SizedBox(height: 8),
                          EventItemCard(
                            eventName: "Leavers Service",
                            date: '12/12/2021',
                          ),
                          SizedBox(height: 8),
                          EventItemCard(
                            eventName: "Hackathon Kickoff",
                            date: '12/12/2021',
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 15, left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "All Vouchers",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          VoucherItemCard(
                            eventName: 'Dinner and Awards',
                            voucherID: 'EV#123456',
                          ),
                          SizedBox(height: 8),
                          VoucherItemCard(
                            eventName: 'Graduation Ceremoney',
                            voucherID: 'EV#1244474',
                          ),
                          SizedBox(height: 8),
                          VoucherItemCard(
                            eventName: 'Dinner and Awards',
                            voucherID: 'EV#00023',
                          ),
                          SizedBox(height: 8),
                          VoucherItemCard(
                            eventName: 'Leavers Night',
                            voucherID: 'EV#123456',
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2));
  }
}
