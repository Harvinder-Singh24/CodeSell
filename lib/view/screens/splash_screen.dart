import 'package:devgram/controllers/helper/constants.dart';
import 'package:devgram/controllers/helper/google_sign_in_provider.dart';
import 'package:devgram/view/omboardprofile/profileedit_screen.dart';
import 'package:devgram/view/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: greenColor,
              );
            } else if (snapshot.hasData) {
              return HomeScreen(
                name: snapshot.data!.displayName,
                email: snapshot.data!.email,
                designation: snapshot.data!.photoURL,
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Something Went Wrong",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return SignUpWidget();
            }
          },
        ));
  }

  Widget SignUpWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logoanimation.gif", height: 400, width: 400),
          const SizedBox(
            height: 150,
          ),
          ShowUpAnimation(
            delayStart: const Duration(seconds: 2),
            animationDuration: const Duration(seconds: 2),
            curve: Curves.easeOutBack,
            direction: Direction.vertical,
            offset: 0.5,
            child: Column(
              children: [
                /* GestureDetector(
                  onTap: () async {
                    final provider = Provider.of<GoggleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                    SharedPreferences sharedPref =
                        await SharedPreferences.getInstance();
                    sharedPref.setBool("isLogin", true);
                    sharedPref.setBool("isGoogleLogin", true);
                    print("Value Set to SharedPref $sharedPref");
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/google.png",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),*/
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Or",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                                  isgooglesignIn: false,
                                )));
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(13)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
