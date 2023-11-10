import 'package:devgram/view/screens/InAppScreens/main_screen.dart';
import 'package:devgram/view/screens/home_screen.dart';
import 'package:devgram/view/screens/splash_screen.dart';
import 'package:devgram/view/screens/splash_screen_loggedin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/helper/google_sign_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const app());
}

class app extends StatefulWidget {
  const app({Key? key}) : super(key: key);

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  bool isLogin = false;

  checkforlogin() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    isLogin = sp.getBool("isLogin") ?? false;
    print("Value of isLogin is $isLogin");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoggleSignInProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          home: FutureBuilder(
            future: checkforlogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              } else {
                if (isLogin) {
                  return const SplashScreenLoggedInUser();
                } else {
                  return const SplashScreen();
                }
              }
            },
          )),
    );
  }
}
