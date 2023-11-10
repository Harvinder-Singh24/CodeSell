import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controllers/helper/constants.dart';

class UserScreen extends StatefulWidget {
  final name;
  const UserScreen({super.key, required this.name});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var documentId;
  var userName;
  var designation;
  var userProject;
  var followers;
  var coinBalance;

  @override
  void initState() {
    super.initState();
    getDocumentId();
    getData();
    print(userName);
    print(designation);
    print(userProject);
    print(followers);
    print(coinBalance);
  }

  getData() {
    print("This name was received from the previous screen: ${widget.name}");
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: widget.name)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          userName = element.data()['name'];
          designation = element.data()['designation'];
          userProject = element.data()['userProject'];
          followers = element.data()['followers'];
          coinBalance = element.data()['coinBalance'];
        });
      });
    });
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
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: const Text("User Screen ")),
      ),
    );
  }

  Widget userScreenUI() {
    //final doc = snapshot.data!.docs.first.data();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: secondaryColor,
          child: Center(
            child: Text(
              'N',
              style: const TextStyle(
                  color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          userName ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.w900, color: Colors.black, fontSize: 20),
        ),
        Text(
          designation ?? '',
          style: const TextStyle(
              fontWeight: FontWeight.w100, color: Colors.black87, fontSize: 12),
        ),
        const Text(
          "Arnlod.netlify.app",
          style: TextStyle(
              fontWeight: FontWeight.w100, color: greenColor, fontSize: 12),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondaryColor,
          ),
          child: const Text(
            "Follow ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(13),
          ),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '10',
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                followers.toString(),
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
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                coinBalance.toString(),
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
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: userProject.length,
                itemBuilder: (BuildContext ctx, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      userProject[index]['imageurl'],
                      fit: BoxFit.cover,
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
