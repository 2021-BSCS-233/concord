import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final IconData actionIcon;
  final String actionName;
  final Function action;

  const OptionTile(
      {super.key, required this.action,
      required this.actionIcon,
      required this.actionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // color: Color(0xFF18181D),
        color: Color(0xFF121218),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        leading: Icon(actionIcon),
        title: Text(
          actionName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: () {
          action();
        },
      ),
    );
  }
}
