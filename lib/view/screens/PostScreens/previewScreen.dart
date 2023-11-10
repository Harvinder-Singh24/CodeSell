import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreviewPostPage extends StatefulWidget {
  String imageUrl;
  PreviewPostPage({super.key, required this.imageUrl});

  @override
  State<PreviewPostPage> createState() => _PreviewPostPageState();
}

class _PreviewPostPageState extends State<PreviewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Image.network(widget.imageUrl),
        ),
      ),
    );
  }
}
