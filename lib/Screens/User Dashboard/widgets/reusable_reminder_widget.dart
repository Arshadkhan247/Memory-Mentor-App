import 'package:flutter/material.dart';
import 'package:mentor/Screens/User%20Dashboard/helper/text_styling.dart';

class ReusableReminderWidget extends StatelessWidget {
  const ReusableReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: Container(
          height: 105,
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(
              0xffD9D9D9,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: Text(
                'Title',
                style: headingTextStyling,
              ),
              subtitle: Text(
                'Description',
                style: textStyling,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
