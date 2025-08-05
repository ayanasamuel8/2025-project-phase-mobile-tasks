import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

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
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Color.fromARGB(255, 16, 95, 160),
                padding: EdgeInsets.all(4),
                shape: badges.BadgeShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  icon_,
                  color: const Color.fromARGB(102, 102, 102, 95),
                ),
              ),
            )
          : IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              icon: Icon(icon_, color: const Color.fromARGB(102, 102, 102, 95)),
            ),
    ),
  );
}
