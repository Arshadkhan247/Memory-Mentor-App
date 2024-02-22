import 'package:flutter/material.dart';

class ReusableChatsContainerWidget extends StatelessWidget {
  const ReusableChatsContainerWidget(
      {super.key, required this.message, required this.textDecoration});

  final String message;
  final textDecoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        child: Text(
          '   $message   ',
          textDirection: textDecoration,
        ),
      ),
    );
  }
}
