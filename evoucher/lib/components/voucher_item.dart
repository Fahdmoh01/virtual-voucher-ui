import 'package:flutter/material.dart';

class VoucherItemCard extends StatelessWidget {
  final String eventName;
  final String voucherID;
  final String eventImage;
  const VoucherItemCard({
    super.key,
    required this.eventName,
    required this.voucherID,
    this.eventImage = 'assets/images/evoucher-logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: Image(
                  image: AssetImage(eventImage),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(voucherID),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
