import 'dart:io';
import 'dart:async';
import 'package:bikerzone/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SemicircleProfileCustom extends StatefulWidget {
  final bool isEdit;
  final dynamic loggedUserId;

  const SemicircleProfileCustom({
    super.key,
    required this.loggedUserId,
    bool? isEdit,
  }) : isEdit = isEdit ?? false;

  @override
  State<SemicircleProfileCustom> createState() =>
      _SemicircleProfileCustomState();
}

class _SemicircleProfileCustomState extends State<SemicircleProfileCustom> {
  File? _imageFile;
  Stream<DocumentSnapshot>? _imageStream;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      String? imageUrl = await uploadImageToFirebase(_imageFile, "user_images");
      await addUserImage(imageUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    _imageStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.loggedUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: _imageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final imageUrl = snapshot.data!.get('image_url') as String;
          return Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 110.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF394949),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120),
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  Positioned(
                    bottom: -50.0,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.isEdit == true) {
                          _pickImage();
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: screenWidth / 6,
                            backgroundImage: imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                    as ImageProvider<Object>
                                : const AssetImage('lib/images/no_image.jpg'),
                          ),
                          if (widget.isEdit)
                            const Positioned.fill(
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
