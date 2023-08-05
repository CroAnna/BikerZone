import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/services/general_service.dart';
import 'package:bikerzone/widgets/filter_dropdown_custom.dart';
import 'package:bikerzone/widgets/ride_card_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindRideScreen extends StatefulWidget {
  const FindRideScreen({super.key});
  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen> {
  bool isFilterShown = false;
  final CollectionReference _referenceRides =
      FirebaseFirestore.instance.collection('rides');
  late Stream<QuerySnapshot> _streamRides;

  @override
  void initState() {
    super.initState();
    _streamRides = _referenceRides.snapshots();
  }

  void _handleDataRecieved(bool filter) {
    setState(() {
      isFilterShown = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                OfferOverviewCustom(
                    isFilterShown: isFilterShown,
                    onDataRecieved: _handleDataRecieved),
                Visibility(
                  visible: isFilterShown,
                  child: const FilterDropdownCustom(),
                ),
                SizedBox(
                  height: 500, // TODO fix
                  child: StreamBuilder(
                    stream: _streamRides,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData) {
                        return Text('Loading...');
                      }

                      final rides = snapshot.data!.docs.map((doc) {
                        return Ride.fromDocument(doc);
                      }).toList();

                      return ListView.builder(
                        itemCount: rides.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future: getDocumentByIdEveryType(
                              "users",
                              rides[index].userId,
                              (snapshot) => UserC.fromDocument(snapshot),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox(
                                  width: 0,
                                );
                              }
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return RideCardCustom(
                                    ride: rides[index], user: data);
                              } else {
                                return const SizedBox(
                                  width: 0,
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OfferOverviewCustom extends StatefulWidget {
  OfferOverviewCustom(
      {super.key, required this.isFilterShown, required this.onDataRecieved});
  bool isFilterShown;
  final void Function(bool) onDataRecieved;

  @override
  State<OfferOverviewCustom> createState() => _OfferOverviewCustomState();
}

class _OfferOverviewCustomState extends State<OfferOverviewCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color((0xFF394949)),
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 65,
          ),
          const Text(
            "Istražite ponudu",
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFFEAEAEA),
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  widget.onDataRecieved(!widget.isFilterShown);
                })
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: const Color(0xFF394949),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    widget.isFilterShown ? Icons.close : Icons.filter_alt,
                    color: const Color(0xFFEAEAEA),
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
