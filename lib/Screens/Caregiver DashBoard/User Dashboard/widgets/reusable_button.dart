import 'package:flutter/material.dart';

class ResuableButtonWidget extends StatelessWidget {
  const ResuableButtonWidget({
    super.key,
    required this.name,
    this.imageUrl,
    this.onTap,
  });

  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 65,
          width: 280,
          decoration: const BoxDecoration(
            color: Color(
              0xffD9D9D9,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                15,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      imageUrl!,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
