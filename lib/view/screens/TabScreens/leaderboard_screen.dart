import 'package:flutter/material.dart';

import '../../../controllers/helper/constants.dart';

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({super.key});

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return leadercard(context, index + 1);
          },
        ),
      ),
    );
  }
}

Widget leadercard(BuildContext context, int index) {
  return Container(
    width: double.infinity,
    height: 80,
    decoration: BoxDecoration(
      color: index == 1
          ? const Color(0xffFFC700)
          : index == 2
              ? Colors.grey
              : index == 3
                  ? Colors.brown
                  : boxColor,
      borderRadius: BorderRadius.circular(13),
    ),
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 20),
    child: Row(
      children: [
        Text(
          "#$index",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
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
          children: const [
            Text(
              "Arnload Kemriz",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "UI/UX Designer",
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                  fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        Text(
          "${151 - index}DG",
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
