import 'package:evoucher/screens/event_details.dart';
import 'package:flutter/material.dart';

class EventItemCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String eventImage;
  final String eventCreator;
  final String eventID;
  const EventItemCard({
    super.key,
    required this.eventName,
    required this.date,
    this.eventImage = 'assets/images/evoucher-logo.png',
    this.eventCreator = 'Fahd Mohammed',
    this.eventID = 'EV20230819140345716900',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventName: eventName,
              eventID: eventID,
              eventDate: date,
              eventCreator: eventCreator,
            ),
          ),
        );
      },
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
                  Text(date),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
