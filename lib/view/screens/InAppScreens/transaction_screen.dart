import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../../controllers/helper/constants.dart';
import '../../../controllers/helper/converttime.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var documentId;
  @override
  void initState() {
    super.initState();
    getDocumentId();
  }

  getDocumentId() async {
    try {
      var collection = FirebaseFirestore.instance.collection('users');
      var querySnapshots = await collection.get();
      for (var snapshot in querySnapshots.docs) {
        if (mounted) {
          setState(() {
            documentId = snapshot.id;
          });
        }
      }
    } on Exception catch (e) {
      print('Error getting document ID: $e');
    }
  }

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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(documentId)
                .collection('projectNotifications')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                // If there is data in the collection, show the post card
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    var userName = doc['userName'];
                    var message = doc['message'];
                    var imgUrl = doc['imageUrl'];
                    var price = doc['price'];
                    final timeago =
                        ConvertTime().convertToAgo(doc['time'].toDate());
                    return leadercard(
                        context, imgUrl, message, userName, timeago, price);
                  }).toList(),
                );
              } else {
                // If there is no data in the collection, show the message
                return const Center(
                  child: Text('No Notifications'),
                );
              }
            },
          )),
    );
  }
}

Widget leadercard(BuildContext context, String imgUrl, String message,
    String userName, dynamic timeAgo, dynamic price) {
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
        CircleAvatar(
          backgroundColor: greenColor,
          radius: 20,
          child: Center(
            child: Text(userName[0],
                style: const TextStyle(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
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
                    text: '$userName purchased your project',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily),
                    children: [
                      TextSpan(
                        text: '+' + '$price' + 'DG',
                        style: TextStyle(
                          color: greenColor,
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      )
                    ]),
              ),
            ),
            Text(
              timeAgo,
              style: const TextStyle(
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
            imgUrl,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}
