import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsNavTile extends StatelessWidget {
  final Widget page;
  final String tileText;
  final IconData tileIcon;
  final bool? subTile;

  const SettingsNavTile(
      {super.key,
      required this.page,
      required this.tileText,
      required this.tileIcon,
      this.subTile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (subTile ?? false)
          ? const EdgeInsets.symmetric(vertical: 2)
          : const EdgeInsets.all(7),
      decoration: (subTile ?? false)
          ? null
          : const BoxDecoration(
              color: Color(0xFF121218),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
      child: InkWell(
        onTap: () {
          Get.to(page);
        },
        child: ListTile(
          leading: Icon(
            tileIcon,
            color: Colors.white,
          ),
          title: Text(
            tileText,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SettingsToggleTile extends StatelessWidget {
  final String tileText;
  final bool toggleValue;
  final IconData tileIcon;
  final bool? subTile;
  final bool? hasSubTiles;
  final Function(bool value) toggleFunction;

  const SettingsToggleTile(
      {super.key,
      required this.toggleValue,
      required this.toggleFunction,
      required this.tileText,
      required this.tileIcon,
      this.subTile,
      this.hasSubTiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (subTile ?? false)
          ? const EdgeInsets.symmetric(vertical: 2)
          : const EdgeInsets.all(7),
      decoration: (subTile ?? false)
          ? null
          : const BoxDecoration(
              color: Color(0xFF121218),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
      child: ListTile(
        leading: Icon(
          tileIcon, // Globe icon
          color: Colors.white,
          size: 24.0,
        ),
        title: Text(
          tileText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: toggleValue,
          onChanged: (value) {
            toggleFunction(value);
          },
          activeColor: Colors.blue,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[700],
        ),
      ),
    );
  }
}
