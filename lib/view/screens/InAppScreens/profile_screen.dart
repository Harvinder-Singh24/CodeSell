import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devgram/controllers/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:show_up_animation/show_up_animation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

    print(documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  IconlyBold.setting,
                  color: Colors.black,
                ),
              )
            ],
            leading: const Icon(IconlyBold.graph, color: Colors.black)),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const CircularProgressIndicator();
            } else {
              return profielScreenUI(snapshot);
            }
          },
        ));
  }

  Widget profielScreenUI(AsyncSnapshot snapshot) {
    final doc = snapshot.data!.docs.first.data();
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          CircleAvatar(
              radius: 70,
              backgroundColor: secondaryColor,
              child: Center(
                child: Text(
                  doc['name'][0],
                  style: const TextStyle(
                      color: blackColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            doc['name'],
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.black, fontSize: 20),
          ),
          Text(
            doc['designation'],
            style: const TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.black87,
                fontSize: 12),
          ),
          const Text(
            "Arnlod.netlify.app",
            style: TextStyle(
                fontWeight: FontWeight.w100, color: greenColor, fontSize: 12),
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(13),
            ),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${doc['myproject'].length}' ?? '0',
                          style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        const Text("Projects",
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.black,
                                fontSize: 12)),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doc['followers'].toString() ?? '0',
                          style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        const Text(
                          "Followers",
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doc['coinBalance'].toString() ?? '0',
                          style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        const Text(
                          "DGCoin",
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ])
                ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: doc['myproject'].length == 0
                  ? const Center(
                      child: Text(
                      "No Project Uploaded",
                      style: TextStyle(color: Colors.black),
                    ))
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: doc['myproject'].length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.network(
                            doc['myproject'][index]['imageurl'],
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
            ),
          )
        ],
      ),
    );
  }
}
