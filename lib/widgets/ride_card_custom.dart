import 'package:bikerzone/models/ride.dart';
import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/ride_details_screen.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RideCardCustom extends StatefulWidget {
  RideCardCustom({super.key, required this.ride, required this.user});
  Ride ride;
  UserC user;

  @override
  State<RideCardCustom> createState() => _RideCardCustomState();
}

class _RideCardCustomState extends State<RideCardCustom> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.92;

    return widget.ride.startDaT.isAfter(DateTime.now())
        ? GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                UnanimatedRoute(
                  builder: (context) => RideDetailsScreen(
                    ride: widget.ride,
                    user: widget.user,
                  ),
                ),
              )
            },
            child: Container(
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFEAEAEA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: cardWidth * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA41723),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('d.M.yyyy.').format(widget.ride.startDaT),
                              style: const TextStyle(color: Color(0xFFEAEAEA), fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      DateFormat('H:mm').format(widget.ride.startDaT),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF444444),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'lib/images/destination.png',
                                      height: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      DateFormat('H:mm').format(widget.ride.finishDaT),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF444444),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: cardWidth * 0.30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.ride.startingPoint,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "...",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    widget.ride.finishingPoint,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: cardWidth * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
                            color: Color(0xFFDEDEDE),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.two_wheeler,
                                  color: Color(0xFFA41723),
                                  size: 32,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.ride.acceptType == "-" ? "Svi motori" : widget.ride.acceptType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF444444),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "• ${widget.ride.highway ? "autocesta" : "bez autoceste"}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF444444),
                                ),
                              ),
                              Text(
                                "• ${widget.ride.pace}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF444444),
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: screenWidth / 20,
                                    backgroundImage: widget.user.imageUrl.isNotEmpty
                                        ? NetworkImage(widget.user.imageUrl) as ImageProvider<Object>
                                        : const AssetImage('lib/images/no_image.jpg'),
                                  ),
                                  Text("  ${widget.user.username}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox(height: 0);
  }
}
