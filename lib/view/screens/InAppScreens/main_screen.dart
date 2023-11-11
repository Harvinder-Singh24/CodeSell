import 'package:devgram/controllers/helper/constants.dart';
import 'package:devgram/view/screens/InAppScreens/wallet_screen.dart';
import 'package:devgram/view/screens/TabScreens/leaderboard_screen.dart';
import 'package:devgram/view/screens/TabScreens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:show_up_animation/show_up_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool changeColor = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "CodeSell",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalletScreen()));
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: whiteColor,
                  child: Icon(IconlyBold.wallet, color: greyColor),
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F8FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TabBar(
                          labelColor: Colors.black,
                          indicator: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          tabs: const [
                            Tab(
                              text: "Discover",
                            ),
                            Tab(text: "Leaderboard"),
                          ]),
                    )),
                const Expanded(
                    child: TabBarView(
                  children: [PostScreen(), LeaderboardWidget()],
                ))
              ],
            ),
          )),
    );
  }
}


/* Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          changeColor = !changeColor;
                        });
                      },
                      child: Container(
                        width: 120,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Text(
                          "Discover",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          changeColor = !changeColor;
                        });
                      },
                      child: Container(
                        width: 170,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: changeColor ? greenColor : boxColor,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Text(
                          "Leaderboard",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )*/