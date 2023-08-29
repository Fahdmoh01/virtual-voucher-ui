// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String total;
  final bool fullWidth;
  // final Color? color;
  final Color? textColor;
  final IconData icon;
  const StatCard({
    super.key,
    required this.title,
    required this.total,
    required this.icon,
    this.fullWidth = false,
    // this.color = const Color.fromRGBO(190, 173, 250, 1),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
    return Container(
      width: fullWidth ? dWidth : dWidth * 0.48,
      height: dHeight * 0.1,
      color: Colors.white,
      child: Card(
        elevation: 3,
        color: Colors.white,
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Colors.green,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: textColor,
            ),
          ),
          subtitle: Text(
            total,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          // isThreeLine: true,
        ),
      ),
    );
  }
}
