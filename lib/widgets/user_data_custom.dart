import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/edit_profile_screen.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserDataCustom extends StatelessWidget {
  final List<Map<String, dynamic>> itemsList;
  final String textTitle;
  final UserC user;
  bool canEdit;
  UserDataCustom({Key? key, required this.itemsList, required this.textTitle, required this.user, this.canEdit = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final listSize = itemsList.length;

    return SizedBox(
      height: listSize * 72,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: screenWidth * 0.9,
            child: Container(
              height: listSize * 59,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color(0xFFEEEEEE),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listSize,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    itemsList[index]["icon"],
                                    color: const Color(0xFFA41723),
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      itemsList[index]["text"],
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.9,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        UnanimatedRoute(builder: (context) => EditProfileScreen(user: user)),
                      );
                    },
                    child: canEdit
                        ? Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFFF9B0B0),
                            ),
                            width: screenWidth * 0.30,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(right: 28),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF444444),
                                  size: 32,
                                ),
                              ),
                            ))
                        : const SizedBox(width: 0),
                  ),
                ),
                Container(
                  width: canEdit ? screenWidth * 0.7 : screenWidth,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFA41723),
                  ),
                  child: Center(
                    child: Text(
                      textTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFFFF3E5), fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
