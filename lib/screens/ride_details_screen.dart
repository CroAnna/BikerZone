import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/edit_ride_screen.dart';
import 'package:bikerzone/screens/friends_profile_screen.dart';
import 'package:bikerzone/services/ride_service.dart';
import 'package:bikerzone/services/user_service.dart';
import 'package:bikerzone/widgets/large_button_custom.dart';
import 'package:bikerzone/widgets/stop_points_custom.dart';
import 'package:bikerzone/widgets/top_navigation_custom.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:bikerzone/widgets/user_card_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  late Stream<DocumentSnapshot?> _streamRide;

  @override
  void initState() {
    super.initState();
    _streamRide = FirebaseFirestore.instance.collection('rides').doc(widget.ride.id).snapshots();
    _streamRiders = FirebaseFirestore.instance.collection('rides').doc(widget.ride.id).collection('riders').snapshots();
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
              TopNavigationCustom(leftIcon: Icons.arrow_back, mainText: "Detalji", rightIcon: null),
              StreamBuilder(
                stream: _streamRide,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final rideObject = Ride.fromDocument(snapshot.data!);

                  return Column(
                    children: [
                      DetailsCard1(screenWidth: screenWidth, ride: rideObject, user: widget.user),
                      DetailsCard2(screenWidth: screenWidth, ride: rideObject, user: widget.user),
                      DetailsCard3(screenWidth: screenWidth, ride: rideObject),
                      StopPointsCustom(screenWidth: screenWidth, ride: rideObject),
                      DetailsCard4(screenWidth: screenWidth, streamRiders: _streamRiders, user: widget.user, ride: rideObject),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsCard1 extends StatelessWidget {
  const DetailsCard1({super.key, required this.screenWidth, required this.ride, required this.user});

  final double screenWidth;
  final Ride ride;
  final UserC user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
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
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Color(0xFF3F3F3F)),
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
                          style: TextStyle(color: Color(0xFF444444), fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat('H:mm').format(ride.startDaT),
                          style: const TextStyle(color: Color(0xFF444444), fontSize: 24, fontWeight: FontWeight.w700),
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
                          style: const TextStyle(color: Color(0xFF444444), fontSize: 24, fontWeight: FontWeight.w700),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      UnanimatedRoute(builder: (context) => FriendsProfileScreen(user: user)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Organizira:",
                            style: TextStyle(color: Color(0xFF444444), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            user.username,
                            style: const TextStyle(color: Color(0xFF444444), fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${user.fullname}, ${calculateYears(user.birthday)}",
                            style: const TextStyle(color: Color(0xFF444444), fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: screenWidth / 20,
                        backgroundImage: user.imageUrl.isNotEmpty
                            ? NetworkImage(user.imageUrl) as ImageProvider<Object>
                            : const AssetImage('lib/images/no_image.jpg'),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
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
  const DetailsCard2({super.key, required this.screenWidth, required this.ride, required this.user});

  final double screenWidth;
  final Ride ride;
  final UserC user;

  @override
  Widget build(BuildContext context) {
    return ride.message == ""
        ? const SizedBox(width: 0)
        : Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
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
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
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
      {"icon": Icons.add_road, "text": ride.highway ? "Putujemo autocestom" : "Ne putujemo autocestom"},
      {
        "icon": Icons.two_wheeler,
        "text": ride.acceptType == "-" ? "Prihvaćamo sve tipove motora" : "Preferiramo tip: ${ride.acceptType.toLowerCase()}"
      },
      {
        "icon": Icons.people_alt,
        "text": ride.maxPeople == 0 ? "Nema ograničenja broja ljudi" : "Max broj ljudi u grupi: ${ride.maxPeople}"
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
      margin: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }
}

class DetailsCard4 extends StatefulWidget {
  const DetailsCard4({
    super.key,
    required this.screenWidth,
    required this.streamRiders,
    required this.user,
    required this.ride,
  });

  final double screenWidth;
  final dynamic streamRiders;
  final UserC user;
  final Ride ride;

  @override
  State<DetailsCard4> createState() => _DetailsCard4State();
}

class _DetailsCard4State extends State<DetailsCard4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: widget.screenWidth * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 4),
          ),
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
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                ),
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
            stream: widget.streamRiders,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final riders = snapshot.data!.docs;

              return Column(
                children: [
                  SizedBox(
                    width: 380,
                    height: riders.length == 1 ? 60 : (riders.length - 1) * 91,
                    child: riders.length == 1
                        ? const Center(child: Text("Još nema drugih bajkera na ovoj vožnji."))
                        : ListView.builder(
                            itemCount: riders.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final riderRef = riders[index]['user_id'] as DocumentReference;

                              return FutureBuilder<DocumentSnapshot>(
                                future: riderRef.get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasData && snapshot.data!.exists) {
                                    final riderObject = UserC.fromDocument(snapshot.data!);

                                    return riderObject.uid != widget.user.uid
                                        ? UserCardCustom(user: riderObject, setWidth: 290)
                                        : const SizedBox(height: 0);
                                  } else {
                                    return const Text('User not found');
                                  }
                                },
                              );
                            },
                          ),
                  ),
                  FutureBuilder<bool>(
                    future: checkIfRiderIsInRide(getLoggedUserReference(), widget.ride),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        bool isRiderInRide = snapshot.data ?? false;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 10),
                          child: isRiderInRide
                              ? LargeButtonCustom(
                                  onTap: () async {
                                    if (widget.ride.userId == FirebaseAuth.instance.currentUser!.uid) {
                                      Navigator.push(
                                        context,
                                        UnanimatedRoute(builder: (context) => EditRideScreen(ride: widget.ride)),
                                      );
                                    } else {
                                      final res = await removeUserFromRide(FirebaseAuth.instance.currentUser!.uid, widget.ride.id);
                                      Fluttertoast.showToast(
                                        msg: res == true ? "Uspješno ste uklonjeni!" : "Greška. Pokušajte ponovo.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                                        textColor: Colors.white,
                                      );
                                      if (res == true) {
                                        setState(() {
                                          isRiderInRide = false;
                                        });
                                      }
                                    }
                                  },
                                  btnText:
                                      widget.ride.userId == FirebaseAuth.instance.currentUser!.uid ? "Uredi vožnju" : "Odustani od vožnje",
                                  isRed: widget.ride.userId != FirebaseAuth.instance.currentUser!.uid,
                                )
                              : Column(
                                  children: [
                                    widget.ride.maxPeople == 0 || riders.length != (widget.ride.maxPeople + 1) // 0 = no people limit
                                        ? LargeButtonCustom(
                                            onTap: () async {
                                              final res = await addRiderToThisRide(getLoggedUserReference(), widget.ride.id);

                                              Fluttertoast.showToast(
                                                msg: res == true ? "Uspješno ste se pridružili!" : "Greška. Pokušajte ponovo.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: res == true ? const Color(0xFF528C9E) : const Color(0xFFA41723),
                                                textColor: Colors.white,
                                              );
                                              if (res == true) {
                                                setState(() {
                                                  isRiderInRide = true;
                                                });
                                              }
                                            },
                                            btnText: "Pridruži se ovoj vožnji",
                                          )
                                        : const Center(
                                            child: Text(
                                            "Sva su mjesta zauzeta.",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF444444)),
                                          ))
                                  ],
                                ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
