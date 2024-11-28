import 'package:flutter/material.dart';

//this page is not in use for now
class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Posts',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Public Posts'), Tab(text: 'Following')],
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
        ),
        body: Container(),
      ),
    );
  }
}