import 'package:bikerzone/models/user.dart';
import 'package:bikerzone/screens/friends_profile_screen.dart';
import 'package:bikerzone/widgets/unanimated_route.dart';
import 'package:flutter/material.dart';

class UserCardCustom extends StatelessWidget {
  final UserC user;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final double setWidth;
  final Function()? onTap;

  const UserCardCustom(
      {super.key, required this.user, this.icon, this.color, this.iconColor = Colors.black, this.setWidth = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            UnanimatedRoute(builder: (context) => FriendsProfileScreen(user: user)),
          );
        },
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: Container(
                height: 70,
                alignment: Alignment.centerLeft,
                width: setWidth == 0 ? 330 : setWidth,
                decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    border: Border.all(color: const Color(0xFF0276B4), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0276B4).withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.two_wheeler,
                                size: 24,
                                color: Color(0xFF0276B4),
                              ),
                              const SizedBox(width: 5),
                              Text(user.bike.manufacturer.length > 10
                                  ? "${user.bike.manufacturer.substring(0, 10)}."
                                  : user.bike.manufacturer),
                              const SizedBox(width: 5),
                              Text(user.bike.model),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(13),
                              bottomRight: Radius.circular(13),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Icon(
                              icon,
                              size: 30,
                              color: iconColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 35,
              backgroundImage: user.imageUrl.isNotEmpty
                  ? NetworkImage(user.imageUrl) as ImageProvider<Object>
                  : const AssetImage('lib/images/no_image.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
