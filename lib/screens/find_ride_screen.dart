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
  final CollectionReference _referenceRides = FirebaseFirestore.instance.collection('rides');
  late Stream<QuerySnapshot> _streamRides;
  String? startLocation;
  String? finishLocation;

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

  void _handleFilterData(String start, String finish) {
    setState(() {
      startLocation = start;
      finishLocation = finish;
      if (start != "" && finish != "") {
        _streamRides = _referenceRides.where('starting_point', isEqualTo: start).where('finishing_point', isEqualTo: finish).snapshots();
      } else if (start != "") {
        _streamRides = _referenceRides.where('starting_point', isEqualTo: start).snapshots();
      } else if (finish != "") {
        _streamRides = _referenceRides.where('finishing_point', isEqualTo: finish).snapshots();
      } else {
        _streamRides = _referenceRides.snapshots();
      }
      print("$startLocation$finishLocation$startLocation$finishLocation");
      _handleDataRecieved(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F4),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OfferOverviewCustom(isFilterShown: isFilterShown, onDataRecieved: _handleDataRecieved, onClearFilters: _handleFilterData),
            Visibility(
              visible: isFilterShown,
              child: FilterDropdownCustom(onSearchClicked: _handleFilterData),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _streamRides,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Text('Loading...');
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
                            return RideCardCustom(ride: rides[index], user: data);
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
    );
  }
}

// ignore: must_be_immutable
class OfferOverviewCustom extends StatefulWidget {
  OfferOverviewCustom({super.key, required this.isFilterShown, required this.onDataRecieved, required this.onClearFilters});
  bool isFilterShown;
  final void Function(bool) onDataRecieved;
  final void Function(String, String) onClearFilters;

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
          widget.isFilterShown
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () => {
                      setState(() {
                        widget.onClearFilters("", "");
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
                          widget.isFilterShown ? Icons.delete_forever : null,
                          color: const Color(0xFFEAEAEA),
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
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
            padding: const EdgeInsets.only(right: 20),
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
