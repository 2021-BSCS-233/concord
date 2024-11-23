import 'package:flutter/material.dart';

//this page is not in use for now
class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
      ),
      body: Container(),
    );
  }
}