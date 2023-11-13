import 'dart:async';

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
  CollectionReference projectCollection =
      FirebaseFirestore.instance.collection("projects");
  Timer? _debounce;

  searchUser(String name) {
    return userCollection
        .orderBy('name')
        .startAt([name]).endAt([name + '\uf8ff']).get();
  }

  searchProject(String projectName) {
    return projectCollection
        .where('projectName', isGreaterThanOrEqualTo: projectName)
        .where('projectName', isLessThanOrEqualTo: projectName + '\uf8ff')
        .get();
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
              "Search",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
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
                          searching();
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

  void searching() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      // Cancel previous debounce timer
      if (_debounce != null && _debounce!.isActive) {
        _debounce!.cancel();
      }

      // Debounce the search for a short period (e.g., 500 milliseconds)
      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchUser(searchController.text).then((userResult) {
          searchProject(searchController.text).then((projectResult) {
            setState(() {
              searchSnapshot = userResult;
              searchSnapshot!.docs.addAll(projectResult.docs);
              isLoading = false;
              hasUserSearched = true;
            });

            if (searchSnapshot!.docs.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("No results found")));
            }
          });
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                final documentData =
                    searchSnapshot!.docs[index].data() as Map<String, dynamic>;

                if (documentData.containsKey('designation')) {
                  return userCard(
                    context,
                    documentData['name'],
                    documentData['designation'],
                  );
                } else if (documentData.containsKey('projectName')) {
                  return projectCard(
                    context,
                    documentData['projectName'],
                    documentData[
                        'otherData'], // Add the correct key for other project data
                  );
                } else {
                  return const SizedBox(); // Handle other cases if needed
                }
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

  Widget userCard(BuildContext context, String name, String designation) {
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
          const Row(
            children: [
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

Widget projectCard(BuildContext context, String projectName, String otherData) {
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
        // Project Image or Icon (customize as needed)
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue, // Example color, customize as needed
          ),
          child: const Icon(
            Icons.folder, // Example icon, customize as needed
            color: whiteColor,
          ),
        ),
        const SizedBox(width: 10),
        // Project Name
        Text(
          projectName,
          style: const TextStyle(
              color: blackColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        // Other Project Data (e.g., Date, Size, etc.)
        Text(
          otherData,
          style: const TextStyle(
              fontWeight: FontWeight.w100, color: blackColor, fontSize: 12),
        ),
      ],
    ),
  );
}
