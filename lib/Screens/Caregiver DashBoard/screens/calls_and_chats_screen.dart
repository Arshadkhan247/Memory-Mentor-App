import 'package:flutter/material.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/User%20Dashboard/helper/text_styling.dart';
import 'package:mentor/Screens/Caregiver%20DashBoard/User%20Dashboard/widgets/Reusable_chats_container.dart';

class CaregiverCallsAndChatsScreen extends StatefulWidget {
  const CaregiverCallsAndChatsScreen({super.key});

  @override
  State<CaregiverCallsAndChatsScreen> createState() =>
      _CallsAndChatsScreenState();
}

class _CallsAndChatsScreenState extends State<CaregiverCallsAndChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xffD9D9D9,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profileimage.png'),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Patient',
              style: textStyling,
            ),
            const SizedBox(
              width: 90,
            ),
            const Icon(Icons.video_call_rounded),
            const SizedBox(
              width: 15,
            ),
            const Icon(Icons.call),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/chatBack.jpg',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReusableChatsContainerWidget(
                  message: 'Hi,', textDecoration: TextDirection.ltr),
              const Align(
                alignment: Alignment.topRight,
                child: ReusableChatsContainerWidget(
                    message: 'Hi,', textDecoration: TextDirection.ltr),
              ),
              const ReusableChatsContainerWidget(
                  message: 'How Are You?,', textDecoration: TextDirection.ltr),
              const Align(
                alignment: Alignment.topRight,
                child: ReusableChatsContainerWidget(
                    message: 'Feeling Well,What about You,',
                    textDecoration: TextDirection.ltr),
              ),
              const ReusableChatsContainerWidget(
                  message: 'Good,i wanna ask about notes',
                  textDecoration: TextDirection.ltr),
              const ReusableChatsContainerWidget(
                  message: 'Hi,', textDecoration: TextDirection.ltr),
              const Align(
                alignment: Alignment.topRight,
                child: ReusableChatsContainerWidget(
                    message: 'Hi,', textDecoration: TextDirection.ltr),
              ),
              const ReusableChatsContainerWidget(
                  message: 'How Are You?,', textDecoration: TextDirection.ltr),
              const Align(
                alignment: Alignment.topRight,
                child: ReusableChatsContainerWidget(
                    message: 'Feeling Well,What about You,',
                    textDecoration: TextDirection.ltr),
              ),
              const ReusableChatsContainerWidget(
                  message: 'Good,i wanna ask about notes',
                  textDecoration: TextDirection.ltr),
              const SizedBox(
                height: 125,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Removes the underline
                          hintText: 'Enter Your Message',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    'assets/sendarrow.png',
                    height: 30,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
