import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../../controllers/helper/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? searchList;
  final searchController = TextEditingController();
  bool isLoading = false;
  bool hasUserSearched = false;
  QuerySnapshot? searchSnapshot;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  searchUser(String name) {
    return userCollection
        .orderBy('name')
        .startAt([name]).endAt([name + '\uf8ff']).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   title: const Text(
        //     "Search",
        //     style: TextStyle(
        //         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        style: const TextStyle(color: blackColor),
                        onChanged: (value) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                            hintText: "ex-Arnload Kemriz",
                            hintStyle:
                                TextStyle(fontSize: 12, color: blackColor),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          searchingUser();
                        },
                        child: const Icon(
                          IconlyLight.search,
                          color: blackColor,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: greenColor),
                      )
                    : searchDataWidget()
              ],
            ),
          ),
        ));
  }

  void searchingUser() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      searchUser(searchController.text).then((value) {
        searchSnapshot = value;
        isLoading = false;
        hasUserSearched = true;
        if (value.docs.isEmpty) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text("No user found")));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Invalid name",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }

  Widget searchDataWidget() {
    return hasUserSearched
        ? Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: searchSnapshot!.docs.length,
              itemBuilder: (context, index) {
                return leadercard(
                  context,
                  searchSnapshot!.docs[index]['name'],
                  searchSnapshot!.docs[index]['designation'],
                );
              },
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: const Text(
              "Search Here",
              style: TextStyle(color: Colors.white),
            ),
          );
  }

  Widget leadercard(BuildContext context, String name, String designation) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 20),
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
              Text(
                name,
                style: const TextStyle(
                    color: blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                designation,
                style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    color: blackColor,
                    fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: const [
              CircleAvatar(
                radius: 20,
                backgroundColor: greenColor,
                child: Icon(IconlyBold.addUser, color: Colors.white),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundColor: greenColor,
                child: Icon(IconlyBold.arrowRight, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
