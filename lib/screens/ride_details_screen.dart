import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/stop_points_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RideDetailsScreen extends StatefulWidget {
  RideDetailsScreen({super.key, required this.ride, required this.user});
  Ride ride;
  UserC user;

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  late Stream<QuerySnapshot> _streamRiders;

  @override
  void initState() {
    super.initState();
    _streamRiders = FirebaseFirestore.instance
        .collection('rides')
        .doc(widget.ride.id)
        .collection('riders')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopNavigationCustom(
                  leftIcon: Icons.arrow_back,
                  mainText: "Detalji",
                  rightIcon: null),
              DetailsCard1(
                  screenWidth: screenWidth,
                  ride: widget.ride,
                  user: widget.user),
              DetailsCard2(
                  screenWidth: screenWidth,
                  ride: widget.ride,
                  user: widget.user),
              DetailsCard3(screenWidth: screenWidth, ride: widget.ride),
              StopPointsCustom(screenWidth: screenWidth, ride: widget.ride),
              DetailsCard4(
                  screenWidth: screenWidth, streamRiders: _streamRiders),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const LargeButtonCustom(
                    onTap: null, btnText: "Pridruži se ovoj vožnji"),
              )
            ],
          ),
        ),
      ),
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
                          "${user.fullname}, ${calculateYears(user.birthday)}",
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
    required this.ride,
  });
  final Ride ride;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
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
      {
        "icon": Icons.people_alt,
        "text": "Max broj ljudi u grupi: ${ride.maxPeople}"
      },
      {"icon": Icons.speed, "text": ride.pace},
    ];
    return Container(
      height: 210,
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

class DetailsCard4 extends StatelessWidget {
  const DetailsCard4(
      {super.key, required this.screenWidth, required this.streamRiders});
  final double screenWidth;
  final dynamic streamRiders;

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
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF444444),
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
                  Icon(Icons.emoji_people, color: Color(0xFFEAEAEA)),
                  Icon(Icons.two_wheeler, color: Color(0xFFEAEAEA)),
                  SizedBox(width: 10),
                  Text(
                    "Ostali vozači:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFEAEAEA),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: streamRiders,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final riders = snapshot.data!.docs;

                return SizedBox(
                  height: riders.isEmpty ? 60 : riders.length * 91,
                  child: riders.isEmpty
                      ? const Center(
                          child:
                              Text("Još nema drugih bajkera na ovoj vožnji."))
                      : ListView.builder(
                          itemCount: riders.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final riderRef =
                                riders[index]['user_id'] as DocumentReference;

                            return FutureBuilder<DocumentSnapshot>(
                              future: riderRef.get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final riderObject =
                                      UserC.fromDocument(snapshot.data!);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            height: 70,
                                            alignment: Alignment.centerLeft,
                                            width: screenWidth * 0.7,
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFEAEAEA),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFF0276B4),
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF0276B4)
                                                            .withOpacity(0.5),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 4),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 35),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    riderObject.username,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF444444)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.two_wheeler,
                                                        size: 24,
                                                        color:
                                                            Color(0xFF0276B4),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(riderObject.bike),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage: riderObject
                                                  .imageUrl.isNotEmpty
                                              ? NetworkImage(
                                                      riderObject.imageUrl)
                                                  as ImageProvider<Object>
                                              : const AssetImage(
                                                  'lib/images/no_image.jpg'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const Text('User not found');
                                }
                              },
                            );
                          }),
                );
              })
        ],
      ),
    );
  }
}
