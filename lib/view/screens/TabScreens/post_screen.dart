import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devgram/controllers/helper/constants.dart';
import 'package:devgram/controllers/helper/converttime.dart';
import 'package:devgram/view/screens/PostScreens/previewScreen.dart';
import 'package:devgram/view/screens/UserScreen/userScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var imageurl;
  var price;
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
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('projects').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              // If there is data in the collection, show the post card
              return postCard(context, snapshot);
            } else {
              // If there is no data in the collection, show the message
              return const Center(
                child: Text('No Projects Available'),
              );
            }
          },
        ),
      ),
    );
  }

  void purchaseProject() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            color: whiteColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Are you sure ?",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Cancel',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Purchase',
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget postCard(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: snapshot.data!.docs.map((doc) {
        final timeago = ConvertTime().convertToAgo(doc['time'].toDate());
        imageurl = doc['imageurl'];
        price = doc['price'];
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.52,
          decoration: BoxDecoration(
            color: const Color(0xffF8F8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserScreen(
                              name: doc['name'],
                            ),
                          ),
                        );
                        print("This name was clicked ${doc['name']}");
                      },
                      child: CircleAvatar(
                        backgroundColor: greenColor,
                        radius: 20,
                        child: Center(
                          child: Text(doc['name'][0],
                              style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['name'] ?? "Unknown",
                          style: const TextStyle(
                              color: blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          timeago,
                          style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              color: blackColor,
                              fontSize: 12),
                        )
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      IconlyBold.bookmark,
                      color: whiteColor,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: CachedNetworkImage(
                        imageUrl: doc['imageurl'],
                        placeholder: (context, url) => Container(
                              color: const Color(0xfff5f8fd),
                            ),
                        fit: BoxFit.cover)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    doc['description'],
                    style: const TextStyle(color: blackColor, fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    /*GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPostPage(
                                      imageUrl: imageurl,
                                    )));
                      },
                      child: Container(
                          width: 120,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(IconlyBold.play, color: blackColor),
                              Text(
                                "Preview",
                                style:
                                    TextStyle(color: blackColor, fontSize: 12),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),*/
                    GestureDetector(
                      onTap: () {
                        purchaseProject();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '₹' + doc['price'],
                              style: const TextStyle(
                                  color: blackColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
