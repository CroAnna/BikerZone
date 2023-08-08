import 'package:bikerzone/screens/add_ride_screen.dart';
import 'package:bikerzone/screens/friends_activity_screen.dart';
import 'package:bikerzone/screens/my_rides_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Map<String, dynamic>> itemsList;
    itemsList = [
      {"imgName": "motorbike", "text": "Nova grupna vožnja", "page": const AddRideScreen()},
      {"imgName": "rider", "text": "Moje vožnje", "page": const MyRidesScreen()},
      {"imgName": "world", "text": "Aktivnosti prijatelja", "page": const FriendsActivityScreen()},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25, bottom: 15),
                child: Text(
                  'Dobrodošli natrag!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF3F3F3F)),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => itemsList[index]["page"]),
                                    )
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                                    width: screenWidth * 0.85,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF528C9E),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          child: Image.asset('lib/images/${itemsList[index]["imgName"]}.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text(itemsList[index]["text"],
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: const Color(0xFFEFEFEF),
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black.withOpacity(0.25),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
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
    );
  }
}
