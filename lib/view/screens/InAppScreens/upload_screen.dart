import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devgram/controllers/helper/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:path/path.dart';

class UploadScreen extends StatefulWidget {
  final name, email, designation;
  const UploadScreen({Key? key, this.name, this.email, this.designation})
      : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final PageController controller = PageController(initialPage: 0);
  final storage = FirebaseStorage.instance;
  File? zipFile;
  String? zipname = '';
  bool isSelected = false;
  bool isuploaded = false;
  bool isloading = false;
  final user = FirebaseAuth.instance.currentUser;
  final _descriptionsController = TextEditingController();
  final _priceController = TextEditingController();
  String? zipurl;
  bool? isgoogleLogin;
  String? imgurl;
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference projectReference =
      FirebaseFirestore.instance.collection('projects');
  String? shared_name;
  String? shared_designation;
  String? shared_email;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    final SharedPreferences _sharedPrefrences =
        await SharedPreferences.getInstance();
    shared_name = _sharedPrefrences.getString('name');
    shared_designation = _sharedPrefrences.getString('designation');
    shared_email = _sharedPrefrences.getString('email');
    print(shared_name);
    print(shared_designation);
    print(shared_email);
  }

  Future uploadfile(BuildContext context) async {
    print("Upload Zip File Running");
    final zipRef = storage.ref().child("zip_files/$zipname");
    print('zipfile value is $zipFile');

    final uploadTask = zipRef.putFile(zipFile!);
    // Listen to the upload progress and complete the task
    final downloadUrl = (await uploadTask);

    zipurl = (await downloadUrl.ref.getDownloadURL());

    print('zipurl value is $zipurl');
  }

  Map<dynamic, dynamic> projectData() {
    Map<String, dynamic> data = {
      'description': _descriptionsController.text,
      'price': _priceController.text,
      'imageurl': imgurl,
      'zipName': zipname,
      'zipurl': zipurl,
      'name': shared_name,
      'email': shared_email,
      'designation': shared_designation,
      'time': DateTime.now(),
    };
    return data;
  }

  Future addprojecttouser() async {
    FirebaseFirestore.instance.collection("users").get().then((value) => {
          value.docs.forEach((element) {
            userReference
                .doc(element.id)
                .set({
                  'myproject': FieldValue.arrayUnion([projectData()])
                }, SetOptions(merge: true))
                .then((value) => {
                      print("Project Added to User"),
                    })
                .catchError((error) => {
                      print(error),
                    });
          })
        });
  }

  Future selectAndUploadImage(BuildContext context) async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    // Select image from gallery
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    final storageRef = storage.ref().child("images/${DateTime.now()}.jpg");
    if (result!.files.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Uploading...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      File imageFile = File((result.files.first.path ?? ""));
      final zipRef = storage.ref().child("zip_files/$zipname");

      final uploadTask = storageRef.putFile(imageFile);
      final uploadTaskZip = zipRef.putFile(zipFile!);

      final downloadUrl = (await uploadTask);
      final downloadUrlZip = (await uploadTaskZip);

      zipurl = (await downloadUrlZip.ref.getDownloadURL());
      imgurl = (await downloadUrl.ref.getDownloadURL());
      print("Image uploaded: $imgurl");
      print("Zip uploaded: $zipurl");

      addprojecttouser();

      await projectReference
          .add(projectData())
          .then((value) => {
                setState(() {
                  isloading = false;
                }),
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'Project Uploaded',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Navigator.pop(context),
              })
          .catchError((error) => {
                setState(() {
                  isloading = false;
                }),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Failed to upload: $error",
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              });
    } else {
      print("File Not picked");
    }
  }

  Future selectFile(BuildContext context) async {
    print("select File Running");
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['zip']);

    if (result!.files.isNotEmpty == true) {
      zipFile = File((result.files.first.path ?? ""));
      setState(() {
        zipname = result.files.first.name;
        isSelected = true;
      }); // do something with the downloadUrl
      print(zipFile);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'File Selected',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     "Upload Project",
      //     style: TextStyle(
      //         color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            showBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: controller,
                            children: [
                              page1(controller, context),
                              page2(controller, context),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_descriptionsController.text.isNotEmpty &&
                                _priceController.text.isNotEmpty) {
                              controller.nextPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Please fill all the fields',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: isloading
                                ? const CircularProgressIndicator()
                                : const Text("Next"),
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(13)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/upload.png"),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "*Choose the zip file for your project",
                    style: TextStyle(color: greyColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget page1(PageController controller, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        height: 300,
        margin: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 60,
                ),
                child: const Text(
                  "Upload Project",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    _descriptionsController.clear();
                    _priceController.clear();
                    Navigator.pop(context);
                    setState(() {
                      isSelected = false;
                    });
                  },
                  child:
                      const Icon(IconlyBold.closeSquare, color: Colors.black)),
            ]),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () {
                  selectFile(context);
                },
                child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: isSelected
                        ? const Icon(Icons.check)
                        : const Icon(Icons.add))),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: _descriptionsController,
                keyboardType: TextInputType.multiline,
                maxLines: null, //
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    IconlyBold.document,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  hintText: "Description for the project",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    IconlyBold.wallet,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  hintText: "Price for project",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget page2(PageController controller, BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
                onTap: () {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: const Icon(IconlyBold.arrowLeft, color: Colors.black)),
            const Text(
              "Preview For Project",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _descriptionsController.clear();
                  _priceController.clear();
                },
                child: const Icon(IconlyBold.closeSquare, color: Colors.black)),
          ]),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              selectAndUploadImage(context);
            },
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                  color: greenColor, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
