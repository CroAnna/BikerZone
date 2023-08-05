import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RideDetailsScreen extends StatelessWidget {
  RideDetailsScreen({super.key, required this.ride, required this.user});
  Ride ride;
  UserC user;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final List<Map<String, dynamic>> itemsList;
    itemsList = [
      {"icon": Icons.location_on, "text": ride.exactStartingPoint},
      {
        "icon": Icons.add_road,
        "text": ride.highway ? "Putujemo autocestom" : "Ne putujemo autocestom"
      },
      {
        "icon": Icons.two_wheeler,
        "text": ride.acceptType == "Svi motori"
            ? "Prihvaćamo sve tipove motora"
            : "Preferiramo tip ${ride.acceptType}"
      },
      {"icon": Icons.info_outline, "text": ride.exactStartingPoint},
      {
        "icon": Icons.people_alt,
        "text": "Max broj ljudi u grupi: ${ride.maxPeople}"
      },
      {"icon": Icons.speed, "text": ride.pace},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const TopNavigationCustom(
                leftIcon: Icons.arrow_back,
                mainText: "Detalji",
                rightIcon: null),
            DetailsCard1(screenWidth: screenWidth, ride: ride, user: user),
            DetailsCard2(screenWidth: screenWidth, ride: ride, user: user),
            DetailsCard3(screenWidth: screenWidth, itemsList: itemsList),
          ],
        ),
      )),
    );
  }
}

class DetailsCard1 extends StatelessWidget {
  const DetailsCard1(
      {super.key,
      required this.screenWidth,
      required this.ride,
      required this.user});

  final double screenWidth;
  final Ride ride;
  final UserC user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: screenWidth * 0.9,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: const Color(0xFFF9B0B0),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("lib/images/details-background.jpg"),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFDFDFDF),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    "${ride.startingPoint} - ${ride.finishingPoint}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Color(0xFF3F3F3F)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Polazak:",
                          style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat('H:mm').format(ride.startDaT),
                          style: const TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Image.asset(
                      'lib/images/destination.png',
                      height: 60,
                    ),
                    Column(
                      children: [
                        const Text("Okvirni\ndolazak:"),
                        Text(
                          DateFormat('H:mm').format(ride.finishDaT),
                          style: const TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Organizira:",
                          style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          user.username,
                          style: const TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${user.fullname}, 20", // TODO add birthday field to firebase and model
                          style: const TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                        radius: screenWidth / 15,
                        backgroundImage: NetworkImage(user.imageUrl)),
                    const SizedBox(width: 5),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class DetailsCard2 extends StatelessWidget {
  const DetailsCard2(
      {super.key,
      required this.screenWidth,
      required this.ride,
      required this.user});

  final double screenWidth;
  final Ride ride;
  final UserC user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.57,
            decoration: BoxDecoration(
              color: const Color(0xFFF9B0B0),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                )
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.info, color: Color(0xFFA41723)),
                  SizedBox(width: 5),
                  Text(
                    "Poruka organizatora:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              ride.message,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3F3F3F),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailsCard3 extends StatelessWidget {
  const DetailsCard3({
    super.key,
    required this.screenWidth,
    required this.itemsList,
  });

  final double screenWidth;
  final dynamic itemsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 4),
          )
        ],
      ),
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xFF444444)),
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
    );
  }
}
