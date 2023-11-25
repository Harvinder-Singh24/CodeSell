import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devgram/controllers/helper/constants.dart';
import 'package:devgram/view/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ProfileEditScreen extends StatefulWidget {
  bool? isgooglesignIn = false;
  ProfileEditScreen({Key? key, this.isgooglesignIn}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final controller = PageController(initialPage: 0);
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final designationController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void authenticateUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString());

      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        sendDataToFirebase();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to add user",
                style: TextStyle(color: Colors.white)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Authentication Error" + '$e',
              style: const TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  void sendDataToFirebase() async {
    setState(() {
      isLoading = true;
    });
    authenticateUser();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    SharedPreferences pref = await SharedPreferences.getInstance();
    await users
        .add({
          'email': emailController.text,
          'name': nameController.text,
          'designation': designationController.text,
          'profilepic': '',
          'coinBalance': 0,
          'followers': 0,
          'myproject': [],
          'userId': FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => {
              setState(() {
                isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: greenColor,
                  content: Text("Account Created",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              pref.setBool("isLogin", true),
              pref.setString("email", emailController.text),
              pref.setString("name", nameController.text),
              pref.setString("designation", designationController.text),
              Navigator.of(context).pushReplacement(_createRoute()),
              print("Value Set of isLogin to true"),
            })
        .catchError((error) => {
              setState(() {
                isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Failed to add user: $error",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            });
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: const Icon(Icons.close, color: Colors.black)),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                emailwidget(context),
                passwordwidget(context),
                namewidget(context),
                proffesionalwidget(context),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              {
                if (controller.page == 0) {
                  if (emailController.text.isNotEmpty) {
                    if (emailController.text.contains("@")) {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Please Enter Valid Email",
                            style: TextStyle(color: Colors.white)),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Please Enter Email",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }
                } else if (controller.page == 1) {
                  if (passwordController.text.isNotEmpty) {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Please Enter Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }
                } else if (controller.page == 2) {
                  if (nameController.text.isNotEmpty) {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Please Enter Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }
                } else if (controller.page == 3) {
                  if (designationController.text.isNotEmpty) {
                    authenticateUser();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Please Enter Designation",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }
                }
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondaryColor,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              controller.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            },
            child: const Text("Prev",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ])),
      ),
    );
  }

  Widget emailwidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 150, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Enter your ',
              style: TextStyle(fontSize: 30, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Email?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: secondaryColor),
                ),
              ],
            ),
          ),
          const Text(
            "Enter your email to verify",
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: emailController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: greenColor,
                ),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
                hintText: "Email",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor)),
                enabledBorder: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget passwordwidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 150, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Enter your ',
              style: TextStyle(fontSize: 30, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Password?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: secondaryColor),
                ),
              ],
            ),
          ),
          const Text(
            "Enter your password",
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: passwordController,
            style: const TextStyle(color: Colors.black),
            obscureText: false,
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: greenColor,
                ),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
                hintText: "Password",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor)),
                enabledBorder: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget namewidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 150, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Enter your ',
              style: TextStyle(fontSize: 30, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Name?',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: greenColor),
                ),
              ],
            ),
          ),
          const Text(
            "Tell us what we should call you",
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: nameController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.person_add,
                  color: secondaryColor,
                ),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
                hintText: "Name",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor)),
                enabledBorder: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget proffesionalwidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 150, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: 'Your Proffesion',
              style: TextStyle(fontSize: 30, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Work?',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: greenColor),
                ),
              ],
            ),
          ),
          const Text(
            "Tell us your work",
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: designationController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.person_add,
                  color: greenColor,
                ),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
                hintText: "ex- Developer",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greenColor)),
                enabledBorder: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) => HomeScreen(
              email: emailController.text,
              name: nameController.text,
              designation: designationController.text,
            )),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(8.4, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
              position: animation.drive(tween), child: child);
        });
  }
}
