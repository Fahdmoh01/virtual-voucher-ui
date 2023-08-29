// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  const EventCard(
      {super.key, required this.title, required this.date, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      child: Card(
        color: const Color.fromARGB(255, 137, 62, 151),
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          // isThreeLine: true,
        ),
      ),
    );
  }
}
