import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../../controllers/helper/constants.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Notificatios",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          )),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return leadercard(
              context,
            );
          },
        ),
      ),
    );
  }
}

Widget leadercard(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 80,
    // decoration: BoxDecoration(
    //   color: whiteColor,
    //   borderRadius: BorderRadius.circular(13),
    // ),
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 30),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg"),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170,
              child: RichText(
                text: TextSpan(
                    text: 'Arnload purchased your project',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily),
                    children: [
                      TextSpan(
                        text: '+40DG',
                        style: TextStyle(
                          color: greenColor,
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      )
                    ]),
              ),
            ),
            const Text(
              "42min ago",
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Color.fromRGBO(158, 158, 158, 1),
                  fontSize: 10),
            ),
          ],
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.network(
            "https://cdn.dribbble.com/users/1997192/screenshots/14513385/media/28a22d492e7e4e43cfaaa0f4c4248a05.png?compress=1&resize=400x300",
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}
