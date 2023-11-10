import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devgram/controllers/helper/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final collection = FirebaseFirestore.instance.collection('users');
  var documentId;

  @override
  void initState() {
    super.initState();
    getDocumentId();
  }

  getDocumentId() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docs) {
      setState(() {
        documentId = snapshot.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            IconlyBold.arrowLeftSquare,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(documentId).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');
            if (snapshot.hasData) {
              var output = snapshot.data!.data();
              var value = output!['coinBalance'];
              print(value); // <-- Your value
              return walletScreenUI(value);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget walletScreenUI(var balance) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Your Balance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '$balance DG',
          style: const TextStyle(
            color: greenColor,
            fontSize: 25,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: greenColor,
          ),
          child: const Text(
            "Buy Coins ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 20, top: 30),
          child: const Text(
            "Latest Transactions",
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w100),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return leadercard(context);
            },
          ),
        ),
      ],
    );
  }

  Widget leadercard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
              SizedBox(
                width: 170,
                child: RichText(
                  text: TextSpan(
                      text: 'Purchased Successfully for ',
                      style: TextStyle(
                          color: Colors.white,
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
          const Icon(Icons.verified_rounded, color: greenColor, size: 30)
        ],
      ),
    );
  }
}


/*Expanded(
      child: ListView(
        children: snapshot.data!.docs.map((doc) {
          final balance = doc['coinBalance'];
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Your Balance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '$balance DG',
                  style: const TextStyle(
                    color: greenColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: greenColor,
                  ),
                  child: const Text(
                    "Buy Coins ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 20, top: 30),
                  child: const Text(
                    "Latest Transactions",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return leadercard(context);
                  },
                )),
              ],
            ),
          );
        }).toList(),
      ),
    );*/
