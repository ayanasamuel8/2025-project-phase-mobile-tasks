import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

Widget customIcon(IconData? icon_, bool addBadge, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: SizedBox(
      child: addBadge
          ? badges.Badge(
              position: badges.BadgePosition.topEnd(top: 9, end: 13),
              badgeStyle: badges.BadgeStyle(
                badgeColor: const Color.fromARGB(255, 16, 95, 160),
                padding: EdgeInsets.all(4),
                shape: badges.BadgeShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(icon_, color: Color.fromARGB(102, 102, 102, 95)),
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: Icon(icon_, color: Color.fromARGB(102, 102, 102, 95)),
            ),
    ),
  );
}
