import 'package:bikerzone/models/ride.dart';
import 'package:flutter/material.dart';

class StopPointsCustom extends StatelessWidget {
  const StopPointsCustom({
    super.key,
    required this.screenWidth,
    required this.ride,
  });

  final double screenWidth;
  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: ride.stopPoints.length * 50 + 170,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("lib/images/road-background.jpg"),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * 0.25,
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
                      Icon(Icons.public, color: Color(0xFFA41723)),
                      SizedBox(width: 5),
                      Text(
                        "Ruta:",
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_flags, color: Color(0xFF3F3F3F)),
                        const SizedBox(width: 5),
                        Text(
                          ride.startingPoint,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3F3F3F),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ride.stopPoints.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 6, top: 2),
                                child: Text(
                                  " |",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3F3F3F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.adjust,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  ride.stopPoints[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3F3F3F),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]);
                      },
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 6, top: 2),
                          child: Text(
                            " |",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3F3F3F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_outlined, color: Color(0xFF3F3F3F)),
                        const SizedBox(width: 5),
                        Text(
                          ride.finishingPoint,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF3F3F3F),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
